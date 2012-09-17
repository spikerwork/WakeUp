#cs --------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         Sp1ker

 Script Function:

   The part of WakeUp Script Time Checker (WSTC)
   Parse and analyze network data from RecieveData() function. "Stop transfering" function implemented in RecieveData()

#ce --------------------------------------------------------------------

   Func ParseData($NetworkData, $clientIP)

	  history ("Call to ParseData()")
	  history ("Data from TCP Client — | " & $NetworkData & " |")

	  Switch $NetworkData

	  ; Client sending to server
	  Case "Test"

			PauseTime($ServerPause)
			history ("Found new client! Wrote IP to ini file.")
			IniWrite($resultini, "Network", "Client_IP", $clientIP)
			SendData($clientIP, "Passed", $TCPport+1)

	  Case "Ready"

			SendData($clientIP, "Exit", $TCPport+1)
			PauseTime($ServerPause)

	  ; Server sending to client
	  Case "Passed"

			SendData($clientIP, "Ready", $TCPport)
			$Ready=1
			PauseTime($ServerPause)

	  ; Client finished all tests
	  Case "ClientOff"

			$newfile="Result_" & @YDAY & "-" & @WDAY & " " & @HOUR & @MIN & ".txt"
			FileMove($resultini, $ScriptFolder & "\" & $newfile)
			history ("Client test finished! Move ini file to " & $ScriptFolder & "\" & $newfile)
			ShellExecuteWait('cmd.exe', '/c powercfg /SETACTIVE ' & $OldGUID)
			FileDelete(@StartupCommonDir & "\WakeServer.lnk")
			Exit

	  ; Else data
	  Case Else


		 $Packetarray=StringSplit($NetworkData, "|") ; Extract data to array

		 If $Packetarray[0]==1 Then

			history ("Unrecognized data recieved — | " & $NetworkData & " |. Nothing to do")

		 Else

			Local $packettype=$Packetarray[2]

			If $Packetarray[1]=="ToServer" Then
			   ; Client sending to server

			history ("Client is sending data, so...")

			   Switch $packettype

			   Case "StoreValues"

				  history ("Start storing vars in ini file")
				  IniWrite($resultini, "Network", "Time", currenttime ())

			   Case "MAC"

				  history ("MAC accepted " & $Packetarray[3])
				  IniWrite($resultini, "Network", "MAC", $Packetarray[3])

			   Case "TestRuns"

				  history ("Number of test" & $Packetarray[3])
				  IniWrite($resultini, "Network", "TestRuns", $Packetarray[3])

			   Case "TimeSync"

					Local $timesync

						history ("TimeSync. Client UnixStamp " & $Packetarray[3])
						IniWrite($resultini, "Time", "Client", $Packetarray[3])
						history ("TimeSync. Server UnixStamp " & GetUnixTimeStamp())
						IniWrite($resultini, "Time", "Server", GetUnixTimeStamp())
						$timesync=UnixTimeStampToTime($Packetarray[3])
						_SetTime($timesync[3], $timesync[4], $timesync[5])
						history ("TimeSync. New time " & $timesync[3] & " " & $timesync[4] & " " & $timesync[5])

			   Case "OptionsHRH"

				  ; Need to add parser!!!
				  history ("Number of test" & $Packetarray[3])
				  IniWrite($resultini, "Network", "OptionsOSH", $Packetarray[3])


			   ; Finishing recieve settings of PC

			   Case "StoreValuesFinish"

				  history ("Finish storing values")
				  PauseTime($ServerPause+2)
				  SendData($clientIP, "ToClient|Done", $TCPport+1)
				  PauseTime(5)
				  SendData($clientIP, "Exit", $TCPport+1)


			   ; WakeDaemon send a signal to stop timer
			   Case "Sleep", "Hiber", "Halt"

				  $TimerD = TimerDiff($TimerStart)
				  $TimerD = Round($TimerD/1000,2) ; Returns time in seconds | Wrong time....
				  $TimeStamp=$Packetarray[8]-$TimeStamp

				  history ($packettype & " test finish in " & $TimerD & " sec. DaemonTime:" & $Packetarray[4] & ". DaemonCycles:" & $Packetarray[5])

				  IniWrite($resultini, "Run#" & $Packetarray[3], $packettype & "Timer", $TimerD)
				  IniWrite($resultini, "Run#" & $Packetarray[3], $packettype & "StopReciveAt", currenttime ())
				  IniWrite($resultini, "Run#" & $Packetarray[3], $packettype & "DaemonTime", $Packetarray[4])
				  IniWrite($resultini, "Run#" & $Packetarray[3], $packettype & "DaemonCycles", $Packetarray[5])
				  IniWrite($resultini, "Run#" & $Packetarray[3], $packettype & "TimeStampStartScript", $Packetarray[6])
				  IniWrite($resultini, "Run#" & $Packetarray[3], $packettype & "TimeStampStartWMI", $Packetarray[7])
				  IniWrite($resultini, "Run#" & $Packetarray[3], $packettype & "TimeStampResumeWMI", $Packetarray[8])
				  IniWrite($resultini, "Run#" & $Packetarray[3], $packettype & "TimeStamp", $TimeStamp)

				  PauseTime($ServerPause)
				  SendData($clientIP, "ToClient|Time|" & $packettype & "|" & $TimerD & "|" & $Packetarray[4], $TCPport+1)
				  PauseTime($ServerPause+5)
				  SendData($clientIP, "Exit", $TCPport+1)
				  $TimerStart=0
				  $TimerD=0
				  $TimeStamp=0


			   ; WakeClient send a signal to begin test
			   Case "SleepTest", "HiberTest", "HaltTest" ;

				  Local $testtype=StringTrimright($packettype, 4)

				  history ("Run#" & $Packetarray[3] & " going to " & $testtype)

				  IniWrite($resultini, "Run#" & $Packetarray[3], "To" & $testtype, currenttime ())
				  $Client_MAC=IniRead($resultini, "Network", "MAC", "00:24:1D:12:CC:3B")
				  $Client_MAC=StringReplace($Client_MAC, ":", "")

				  PauseTime($WakeUpPause)

				  history ("Broadcast from ini - " & $server_broadcast)

				  SendMagicPacket($Client_MAC, $server_broadcast)
				  $TimerStart=TimerInit()
				  $TimeStamp=GetUnixTimeStamp()
				  IniWrite($resultini, "Run#" & $Packetarray[3], "WakeFrom" & $testtype & "SendAt", currenttime ())


			   EndSwitch


			ElseIf $Packetarray[1]=="ToClient" Then

			   ; Server sending to client

			history ("Server is sending data, so...")

			   Switch $packettype

			   ; First greeting with server
			   Case "Done"

				  $Done = 1
				  history ("Done - " & $Done)

			   ; WakeClient write the time data from server
			   Case "Time"

				  history ("Time - " & $Packetarray[4])
				  IniWrite($resultini, $current_run, $Packetarray[3], $Packetarray[4]-5) ; Exclude 5 seconds idle time
				  Local $short_time=$Packetarray[4]-$Packetarray[5]
				  history ("Short time - " & $short_time)
				  IniWrite($resultini, $current_run, $Packetarray[3] & "_short", $short_time) ; Exlude all daemon time

			   EndSwitch


			EndIf

		 EndIf


	  EndSwitch

   EndFunc