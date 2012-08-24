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
		 history ("PacketArray — " & $Packetarray[0])
		 
		 If @error Then
			history ("Unrecognized data recieved — | " & $NetworkData & " | Nothing to do")
		 Else
			
			If $Packetarray[0]=="ToServer" Then
			   ; Client sending to server
			history ("Client is sending data... ")
		    
			ElseIf $Packetarray[0]=="ToClient" Then
			   ; Server sending to client
			history ("Server is sending data... ")
		       
			EndIf
		 
		 EndIf
		   
	  
	  EndSwitch

   EndFunc