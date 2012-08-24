; Parse network data from RecieveData() function. "Stop transfering" function implemented in RecieveData()
   Func ParseData($NetworkData, $clientIP)
	  
	  history ("Call to ParseData()")
	  history ("Data from TCP Client — | " & $NetworkData & " |")
	  
	  Switch $NetworkData
	   
	  ; Client sending to server
	  Case "Test"
	  
			Sleep(2000)
			history ("Found new client! Wrote IP to ini file.")
			IniWrite($inifile, "Network", "Client_IP", $clientIP)
			IniWrite($resultini, "Network", "Client_IP", $clientIP)
			SendData($clientIP, "Passed", $TCPport+1)
			
	  Case "Ready"
			
			SendData($clientIP, "Exit", $TCPport+1)
			Sleep(1000)
	  
	  ; Server sending to client
	  Case "Passed"
	   
			SendData($clientIP, "Ready", $TCPport)
			$Ready=1
			Sleep(1000)
	  
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
			   Sleep(2000)
			   SendData($clientIP, "ToClient|Done", $TCPport+1)
			   Sleep(5000)
			   SendData($clientIP, "Exit", $TCPport+1)
			   
			   Case "Sleep"
			   
			   history ("Run#" & $Packetarray[3] & " going to sleep")
			   
			   IniWrite($resultini, "Run#" & $Packetarray[3], "ToSleep", currenttime ())
			   $Client_MAC=IniRead($resultini, "Network", "MAC", "00241D12CC3B")
			   $Client_MAC=StringReplace($Client_MAC, ":", "")
			   
			   Sleep(20000)
			   
			   
			   $broadcast=GetBroadcast ($ipdetails[1][0], $ipdetails[3][0])
			   
			   SendMagicPacket($Client_MAC, $broadcast)
			   IniWrite($resultini, "Run#" & $Packetarray[3], "WakeFromSleepSendAt", currenttime ())
			   
			   Case "SleepStop"
			   
			   IniWrite($resultini, "Run#" & $Packetarray[3], "StopSleepReciveAt", currenttime ())
			   
			   
			   EndSwitch
			   
		    
			ElseIf $Packetarray[1]=="ToClient" Then
			   ; Server sending to client
			   
			history ("Server is sending data, so...")
			
			   Switch $packettype
			   
			   Case "Done"
			   $Done = 1
			   history ("Done - " & $Done)
			   
			   EndSwitch
			
		       
			EndIf
		 
		 EndIf
		   
	  
	  EndSwitch

   EndFunc