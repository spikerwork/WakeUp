; Parse network data from RecieveData() function. "Stop transfering" function implemented in RecieveData()
   Func ParseData($NetworkData, $clientIP)
	  
	  history ("Call to ParseData()")
	  history ("Data from TCP Client — | " & $NetworkData & " |")
	  
	  Switch $NetworkData
	   
	  ; Client sending to server
	  Case "Test"
	  
			PauseTime($ServerPause)
			history ("Found new client! Wrote IP to ini file.")
			IniWrite($inifile, "Network", "Client_IP", $clientIP)
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
	  
	  ; Else data
	  Case Else
		 
		 
		 $Packetarray=StringSplit($NetworkData, "|")
		 
		 history ("Lol — | " & $Packetarray[0] & " ||| " & $Packetarray[1] & " ||| " & $Packetarray[2])
		 
		 If $Packetarray[0]==1 Then
			
			history ("Unrecognized data recieved — | " & $NetworkData & " | Nothing to do")
			
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
			   
			   history ("MAC accepted" & $Packetarray[3])
			   IniWrite($resultini, "Network", "MAC", $Packetarray[3])
			   
			   Case "TestRuns"
			   
			   history ("Number of test" & $Packetarray[3])
			   IniWrite($resultini, "Network", "TestRuns", $Packetarray[3])
			   
			   Case "OptionsHRH"
			   
			   history ("Number of test" & $Packetarray[3])
			   IniWrite($resultini, "Network", "OptionsOSH", $Packetarray[3])
			   
			   ; Need to add parser
			   
			   Case "StoreValuesFinish"
			   
			   history ("Finish storing values")
			   PauseTime($ServerPause)
			   SendData($clientIP, "ToClient|Done", $TCPport+1)
			   PauseTime(5)
			   SendData($clientIP, "Exit", $TCPport+1)
			   
			   
			   ; Sleep TEST
			   
			   Case "SleepTest" ;  WakeClient send
			   
			   history ("Run#" & $Packetarray[3] & " going to sleep")
			   
			   IniWrite($resultini, "Run#" & $Packetarray[3], "ToSleep", currenttime ())
			   $Client_MAC=IniRead($resultini, "Network", "MAC", "00241D12CC3B")
			   $Client_MAC=StringReplace($Client_MAC, ":", "")
			   
			   PauseTime(60)
			   
			   $broadcast=GetBroadcast ($ipdetails[1][0], $ipdetails[3][0])
			   
			   SendMagicPacket($Client_MAC, $broadcast)
			   $TimerStart=TimerInit()
			   IniWrite($resultini, "Run#" & $Packetarray[3], "WakeFromSleepSendAt", currenttime ())
			   
			   Case "Sleep" ; WakeDaemon send
			   $TimerD = TimerDiff($TimerStart)

			   history ("Sleep test finish in " & $TimerD & " msec. DaemonTime:" & $Packetarray[4] & ". DaemonCycles:" & $Packetarray[5])
			   
			   IniWrite($resultini, "Run#" & $Packetarray[3], "StopSleepReciveAt", currenttime ())
			   IniWrite($resultini, "Run#" & $Packetarray[3], "SleepDaemonTime", $Packetarray[4])
			   IniWrite($resultini, "Run#" & $Packetarray[3], "SleepDaemonCycles", $Packetarray[5])
			   
			   PauseTime($ServerPause)
			   SendData($clientIP, "ToClient|Time|" & $packettype & "|" & $TimerD, $TCPport+1)
			   PauseTime($ServerPause+5)
			   SendData($clientIP, "Exit", $TCPport+1)
			   $TimerStart=0
			   $TimerD=0
			   
			   ; Hiber TEST
			   
			   Case "HiberTest" ;  WakeClient send
			   
			   history ("Run#" & $Packetarray[3] & " going to hibernate")
			   
			   IniWrite($resultini, "Run#" & $Packetarray[3], "ToHiber", currenttime ())
			   $Client_MAC=IniRead($resultini, "Network", "MAC", "00241D12CC3B")
			   $Client_MAC=StringReplace($Client_MAC, ":", "")
			   
			   PauseTime(90)
			   
			   $broadcast=GetBroadcast ($ipdetails[1][0], $ipdetails[3][0])
			   
			   SendMagicPacket($Client_MAC, $broadcast)
			   $TimerStart=TimerInit()
			   IniWrite($resultini, "Run#" & $Packetarray[3], "WakeFromHiberSendAt", currenttime ())
			   
			   
			   Case "Hiber" ; WakeDaemon send
			   $TimerD = TimerDiff($TimerStart)

			   history ("Hiber test finish in " & $TimerD & " msec. DaemonTime:" & $Packetarray[4] & ". DaemonCycles:" & $Packetarray[5])
			   
			   IniWrite($resultini, "Run#" & $Packetarray[3], "StopHiberReciveAt", currenttime ())
			   IniWrite($resultini, "Run#" & $Packetarray[3], "HiberDaemonTime", $Packetarray[4])
			   IniWrite($resultini, "Run#" & $Packetarray[3], "HiberDaemonCycles", $Packetarray[5])
			   
			   PauseTime($ServerPause)
			   SendData($clientIP, "ToClient|Time|" & $packettype & "|" & $TimerD, $TCPport+1)
			   PauseTime($ServerPause+5)
			   SendData($clientIP, "Exit", $TCPport+1)
			   $TimerStart=0
			   $TimerD=0
			   
			   ; Halt TEST
			   
			   Case "HaltTest" ;  WakeClient send
			   
			   history ("Run#" & $Packetarray[3] & " going to hibernate")
			   
			   IniWrite($resultini, "Run#" & $Packetarray[3], "ToHalt", currenttime ())
			   $Client_MAC=IniRead($resultini, "Network", "MAC", "00241D12CC3B")
			   $Client_MAC=StringReplace($Client_MAC, ":", "")
			   
			   PauseTime(120)
			   
			   $broadcast=GetBroadcast ($ipdetails[1][0], $ipdetails[3][0])
			   
			   SendMagicPacket($Client_MAC, $broadcast)
			   $TimerStart=TimerInit()
			   IniWrite($resultini, "Run#" & $Packetarray[3], "WakeFromHaltSendAt", currenttime ())
			   
			   
			   Case "Halt" ; WakeDaemon send
			   $TimerD = TimerDiff($TimerStart)

			   history ("Halt test finish in " & $TimerD & " msec. DaemonTime:" & $Packetarray[4] & ". DaemonCycles:" & $Packetarray[5])
			   
			   IniWrite($resultini, "Run#" & $Packetarray[3], "StopHaltReciveAt", currenttime ())
			   IniWrite($resultini, "Run#" & $Packetarray[3], "HaltDaemonTime", $Packetarray[4])
			   IniWrite($resultini, "Run#" & $Packetarray[3], "HaltDaemonCycles", $Packetarray[5])
			   
			   PauseTime($ServerPause)
			   SendData($clientIP, "ToClient|Time|" & $packettype & "|" & $TimerD, $TCPport+1)
			   PauseTime($ServerPause+5)
			   SendData($clientIP, "Exit", $TCPport+1)
			   $TimerStart=0
			   $TimerD=0
			   
   
			   EndSwitch
			   
		    
			ElseIf $Packetarray[1]=="ToClient" Then
			   ; Server sending to client
			   
			history ("Server is sending data, so...")
			
			   Switch $packettype
			   
			   Case "Done"
			   $Done = 1
			   history ("Done - " & $Done)
			   
			   Case "Time"
			   
			   history ("Time - " & $Packetarray[4])
			   IniWrite($resultini, $current_run, $Packetarray[3], $Packetarray[4])
			   
			   EndSwitch
			
		       
			EndIf
		 
		 EndIf
		   
	  
	  EndSwitch

   EndFunc