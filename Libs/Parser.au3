#include-once
#cs --------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         Sp1ker

 Script Function:

   The part of WakeUp Script Time Checker (WSTC)
   Parse and analyze network data from RecieveData() function. "Stop" function implemented in RecieveData()

#ce --------------------------------------------------------------------

   Func ParseData($NetworkData, $clientIP)

	  history ("Call to ParseData()")
	  history ("Data from TCP Client — | " & $NetworkData & " |")

	  Switch $NetworkData

	; Main Client/Server transaction

	; Client sending to server
	  Case "Test"

			PauseTime($ServerPause)
			history ("Found new client! IP logged to ini file.")
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

			FileMove($resultini, $newresultfile)
			history ("Client test finished! Move ini file to " & $newresultfile)
			ShellExecuteWait('cmd.exe', '/c powercfg /SETACTIVE ' & $OldGUID)
			FileDelete(@StartupCommonDir & "\WakeServer.lnk")
			IniWrite($inifile, "Time", "WakeUpPause", 180)
			Exit

	  ; Else data
	  Case Else


		 $Packetarray=StringSplit($NetworkData, "|") ; Extract recieved data to array

		 If $Packetarray[0]==1 Then

			history ("Unrecognized data recieved — | " & $NetworkData & " |. Nothing to do")

		 Else

			Local $packettype=$Packetarray[2] ; Type of packet

			If $Packetarray[1]=="ToServer" Then

			; Client sending information to server

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
						_SetTime($timesync[3], $timesync[4], $timesync[5]) ; Time synchronization between server and client. Set time server as a client
						history ("TimeSync. Old time " & @HOUR & " " & @MIN & " " & @SEC)
						history ("TimeSync. New time " & $timesync[3] & " " & $timesync[4] & " " & $timesync[5])

			   Case "WakeUpPause"

				  ; Set server pause for current client
				  history ("Set server pause for current client - " & $Packetarray[3])
				  IniWrite($inifile, "Time", "WakeUpPause", $Packetarray[3])
				  $WakeUpPause = $Packetarray[3]

			   ; Finishing recieve settings of PC

			   Case "StoreValuesFinish"

				  history ("Finish storing values")
				  PauseTime($ServerPause+2)
				  SendData($clientIP, "ToClient|Done", $TCPport+1)
				  PauseTime(5)
				  SendData($clientIP, "Exit", $TCPport+1)


			   ; WakeDaemon send a signal to stop timer
			   Case "Sleep", "Hiber", "Halt"

					; Check WMI on/off
					  If $Packetarray[8]<>0 Then
					  $TimeStamp=$Packetarray[8]-$TimeStamp
					  Else
					  $TimeStamp=$Packetarray[7]-$TimeStamp
					  EndIf

				  history ($packettype & " test finish in " & $TimeStamp & " sec. DaemonTime:" & $Packetarray[4] & ". DaemonCycles:" & $Packetarray[5])

				  IniWrite($resultini, "Run#" & $Packetarray[3], $packettype & "StopReciveAt", currenttime ())
				  IniWrite($resultini, "Run#" & $Packetarray[3], $packettype & "DaemonTime", $Packetarray[4])
				  IniWrite($resultini, "Run#" & $Packetarray[3], $packettype & "DaemonCycles", $Packetarray[5])
				  IniWrite($resultini, "Run#" & $Packetarray[3], $packettype & "TimeStampStartScript", $Packetarray[6])
				  IniWrite($resultini, "Run#" & $Packetarray[3], $packettype & "TimeStampStartWMI", $Packetarray[7])
				  IniWrite($resultini, "Run#" & $Packetarray[3], $packettype & "TimeStampResumeWMI", $Packetarray[8])
				  IniWrite($resultini, "Run#" & $Packetarray[3], $packettype & "TimeStamp", $TimeStamp)

				  PauseTime($ServerPause)
				  SendData($clientIP, "ToClient|Time|" & $packettype & "|" & $Packetarray[4] & "|" & $TimeStamp, $TCPport+1)
				  PauseTime($ServerPause+5)
				  SendData($clientIP, "Exit", $TCPport+1)

				  $TimeStamp=0


			   ; WakeClient send a signal to begin test
			   Case "SleepTest", "HiberTest", "HaltTest" ;

				  Local $testtype=StringTrimright($packettype, 4) ; Parser to determine test type

				  history ("Run#" & $Packetarray[3] & " going to " & $testtype)

				  IniWrite($resultini, "Run#" & $Packetarray[3], "To" & $testtype, currenttime ())
				  $Client_MAC=IniRead($resultini, "Network", "MAC", "00:24:1D:12:CC:3B")
				  $Client_MAC=StringReplace($Client_MAC, ":", "")

				  PauseTime($WakeUpPause)

				  SendMagicPacket($Client_MAC, $server_broadcast)

				  $TimeStamp=GetUnixTimeStamp()
				  history ("TimeStamp - " & $TimeStamp)
				  IniWrite($resultini, "Run#" & $Packetarray[3], "WakeFrom" & $testtype & "SendAt", currenttime ())


			   EndSwitch


			ElseIf $Packetarray[1]=="ToClient" Then

			   ; Server sending to client

			history ("Server is sending data, so...")

			   Switch $packettype

			   ; First greeting with server
			   Case "Done"

				  $Done = 1
				  history ("Finish greetings client-server - " & $Done)

			   ; WakeClient write the time data from server
			   Case "Time"

				  Local $TotalTime=$Packetarray[4]+$Packetarray[5]
				  history ("DaemonTime - " & $Packetarray[4])
				  IniWrite($resultini, $current_run, $Packetarray[3] & "_DaemonTime", $Packetarray[4]) ; WMI daemon time
				  history ("TimeStamp - " & $Packetarray[5])
				  IniWrite($resultini, $current_run, $Packetarray[3] & "_TimeStamp", $Packetarray[5]) ; TimeStamp
				  history ("Total time - " & $TotalTime)
				  IniWrite($resultini, $current_run, $Packetarray[3] & "_TotalTime", $TotalTime) ; Total time


			   EndSwitch


			EndIf

		 EndIf


	  EndSwitch

   EndFunc