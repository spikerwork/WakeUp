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
		 
		 ;history ("Lol — | " & $Packetarray[0] & " ||| " & $Packetarray[1] & " ||| " & $Packetarray[2])
		 
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
			   ; Need to add parser!!!
			   history ("Number of test" & $Packetarray[3])
			   IniWrite($resultini, "Network", "OptionsOSH", $Packetarray[3])
			   
			
			   ; Finishing recieve settings of PC
			   
			   Case "StoreValuesFinish"
			   
			   history ("Finish storing values")
			   PauseTime($ServerPause)
			   SendData($clientIP, "ToClient|Done", $TCPport+1)
			   PauseTime(5)
			   SendData($clientIP, "Exit", $TCPport+1)
			   
			   
			   ; WakeDaemon send a signal to stop timer
			   Case "Sleep", "Hiber", "Halt"
			   
			   $TimerD = TimerDiff($TimerStart)

			   history ($packettype & " test finish in " & $TimerD & " msec. DaemonTime:" & $Packetarray[4] & ". DaemonCycles:" & $Packetarray[5])
			   
			   IniWrite($resultini, "Run#" & $Packetarray[3], $packettype & "Timer", $TimerD)
			   IniWrite($resultini, "Run#" & $Packetarray[3], $packettype & "StopReciveAt", currenttime ())
			   IniWrite($resultini, "Run#" & $Packetarray[3], $packettype & "DaemonTime", $Packetarray[4])
			   IniWrite($resultini, "Run#" & $Packetarray[3], $packettype & "DaemonCycles", $Packetarray[5])
			   
			   PauseTime($ServerPause)
			   SendData($clientIP, "ToClient|Time|" & $packettype & "|" & $TimerD, $TCPport+1)
			   PauseTime($ServerPause+5)
			   SendData($clientIP, "Exit", $TCPport+1)
			   $TimerStart=0
			   $TimerD=0
			  
						
			   ; WakeClient send a signal to begin test
			   Case "SleepTest", "HiberTest", "HaltTest" ;  
			   
			   Local $testtype=StringTrimright($packettype, 4)
			   
			   history ("Run#" & $Packetarray[3] & " going to " & $testtype)
			   
			   IniWrite($resultini, "Run#" & $Packetarray[3], "To" & $testtype, currenttime ())
			   $Client_MAC=IniRead($resultini, "Network", "MAC", "00241D12CC3B")
			   $Client_MAC=StringReplace($Client_MAC, ":", "")
			   
			   PauseTime(60)
			   
			   $broadcast=GetBroadcast ($ipdetails[1][0], $ipdetails[3][0])
			   
			   SendMagicPacket($Client_MAC, $broadcast)
			   $TimerStart=TimerInit()
			   IniWrite($resultini, "Run#" & $Packetarray[3], "WakeFrom" & $testtype & "SendAt", currenttime ())
			   
   
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