#cs --------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         Sp1ker

 Script Function:
	
   The part of WakeUp Script Time Checker (WSTC)
   It contains network functions and IP

#ce --------------------------------------------------------------------
  
   ;
   ; Work with Magic Packets
   ; http://www.autoitscript.com/forum/topic/29772-copyright-free-wake-on-lan-script/
   ;
   
   ; Send Magic Packet to computer with specified MAC
   Func SendMagicPacket($Dest_Mac, $send_IP)
   history ("Call to SendMagicPacket(). Broadcast IP: " & $send_IP & " (External MAC " & $Dest_Mac & ")")
  
   Local $MACAddress = $Dest_Mac ; WakeUp computer MAC 
   Local $IPAddress = $send_IP ; This is the broadcast address 
   
   UDPStartUp()
   $connexion = UDPOpen($IPAddress, $UDPport)
   $res = UDPSend($connexion, GenerateMagicPacket($MACAddress))
   history ("Magic Packet to MAC " & $MACAddress & " sent. Return code " & $res)
   UDPCloseSocket($connexion)
   UDPShutdown()
   EndFunc
   
   ; This function convert a MAC Address Byte (e.g. "1f") to a char
   Func HexToChar($strHex)
	   
	   Return Chr(Dec($strHex))
	   
   EndFunc

   ; This function generate the "Magic Packet"
   Func GenerateMagicPacket($strMACAddress)
	   
	   Local $MagicPacket = ""
	   Local $MACData = ""
	   
	   For $p = 1 To 11 Step 2
		   $MACData = $MACData & HexToChar(StringMid($strMACAddress, $p, 2))
	   Next
	   
	   For $p = 1 To 6
		   $MagicPacket = HexToChar("ff") & $MagicPacket
	   Next
	   
	   For $p = 1 To 16
		   $MagicPacket = $MagicPacket & $MACData
	   Next
	   
	   history ("Magic Packet for MAC " & $strMACAddress & " generated.")
  	   Return $MagicPacket
	   
	EndFunc
	
   ;
   ; Work with computer IP settings
   ;
	
    ; Get the Hardware IDs and GUID of current network adapter. Addon for IPDetail()
   Func _GetPNPDeviceID($sAdapter)
	  Local $arra[2]
	  
	  history ("Call to GetPNPDeviceID(). Get the Hardware ID of network adapter")
	   Local $oWMIService = ObjGet("winmgmts:{impersonationLevel = impersonate}!\\" & "." & "\root\cimv2")
	   Local $oColItems = $oWMIService.ExecQuery('Select * From Win32_NetworkAdapter Where Name = "' & $sAdapter & '"', "WQL", 0x30)
	   If IsObj($oColItems) Then
		   For $oObjectItem In $oColItems
			   $arra[0]=$oObjectItem.PNPDeviceID
			   $arra[1]=$oObjectItem.GUID
			   
			   history ("Found Hardware ID " & $oObjectItem.PNPDeviceID & " for device " & $sAdapter)
			   history ("Found Hardware GUID " & $oObjectItem.GUID & " for device " & $sAdapter)
			   
			   Return $arra
		   Next
	   EndIf
	   Return SetError(1, 0, "Unknown")
	EndFunc   

   ; Get main information of network adapters
   ; Returns:
   ;
   ; $avArray[0][$iCount] — Description
   ; $avArray[1][$iCount] — IPAddress(0)
   ; $avArray[2][$iCount] — MACAddress
   ; $avArray[3][$iCount] — IPSubnet(0)
   ; $avArray[4][$iCount] — Ven/Dev info
   ; $avArray[5][$iCount] — Physic (1 or 0)
   ; $avArray[6][$iCount] — GUID of adapter
   ;
   ; This function from http://www.autoitscript.com/forum/topic/128276-display-ip-address-default-gateway-dns-servers/
   
   Func _IPDetail()
    history ("Call to network function IPDetail(). Get main information of network adapters")
	Local $iCount = 0
    Local $oWMIService = ObjGet("winmgmts:{impersonationLevel = impersonate}!\\" & "." & "\root\cimv2")
    Local $oColItems = $oWMIService.ExecQuery("Select * From Win32_NetworkAdapterConfiguration Where IPEnabled = True", "WQL", 0x30)
	Local $avArray[7][10]
	Local $physic
	Local $descibe[2]
	
    If IsObj($oColItems) Then
        For $oObjectItem In $oColItems
		   
		   Local $desc = $oObjectItem.Description
		   $descibe = _GetPNPDeviceID($desc)
		   
			
			   $avArray[0][$iCount] = _IsString($oObjectItem.Description)
			   $avArray[1][$iCount] = _IsString($oObjectItem.IPAddress(0))
			   $avArray[2][$iCount] = _IsString($oObjectItem.MACAddress)
			   $avArray[3][$iCount] = _IsString($oObjectItem.IPSubnet(0))
			   $avArray[4][$iCount] = $descibe[0]
			   $avArray[6][$iCount] = $descibe[1]
			   
			   
			If StringInStr($descibe[0], "Ven_") Or StringInStr($descibe[0], "usb") Then
			$avArray[5][$iCount] = 1
			$physic += 1
			   
			history ("Found physical adapter (IP: " & $avArray[1][$iCount] & ") - " & $avArray[0][$iCount] & ". Using for it #" & $iCount)
			Else
			$avArray[5][$iCount] = 0
			EndIf  

		   
			$iCount += 1

		 Next
        
		history ("At least found " & $iCount & " active network adapters and " & $physic & " of them is physic (PCI or USB)")
        		
		Return $avArray
    EndIf
    Return SetError(1, 0, $aReturn)
   EndFunc  
 
   ; Check string function for IPDetail()
   Func _IsString($sString)
    If IsString($sString) Then
        Return $sString
    EndIf
    Return "Not Available"
   EndFunc   
 
   ; Calculate broadcast address for IP/Netmask
   ; From http://www.autoitscript.com/forum/topic/27637-filereadtoarray-multiple-entries-to-be-processed/
   
   Func GetBroadcast ($ip, $netmask)
	  
	  history ("Call to network function GetBroadcast(). Param: IP - " & $ip & ", Netmask - " & $netmask)
	  
	  Local $iparray = StringSplit($ip, ".")
	  local $netmaskarray = StringSplit($netmask, ".")
	  
	  Dim $subnetaddarray[5]
	  Dim $invmaskarray[5]
	  Dim $broadcastaddarray[5]
	   
	  For $i = 1 To $iparray[0]
		 $subnetaddarray[$i] = BitAND($iparray[$i], $netmaskarray[$i])
		 $invmaskarray[$i] = BitNOT($netmaskarray[$i] - 256)
		 $broadcastaddarray[$i] = BitOR($subnetaddarray[$i], $invmaskarray[$i])
	  Next
	   
	  $broadcastadd = $broadcastaddarray[1] & "." & $broadcastaddarray[2] & "." & $broadcastaddarray[3] & "." & $broadcastaddarray[4]
	   
	  $subnetadd = $subnetaddarray[1] & "." & $subnetaddarray[2] & "." & $subnetaddarray[3] & "." & $subnetaddarray[4]
	   
	  $invmask = $invmaskarray[1] & "." & $invmaskarray[2] & "." & $invmaskarray[3] & "." & $invmaskarray[4]
	   
	  $iprange = $subnetaddarray[1] & "." & $subnetaddarray[2] & "." & $subnetaddarray[3] & "." & $subnetaddarray[4] + 1 & "-" & $broadcastaddarray[1] & "." & $broadcastaddarray[2] & "." & $broadcastaddarray[3] & "." & $broadcastaddarray[4] - 1
	   
	  $hosts = ($invmaskarray[4] + 1) * ($invmaskarray[3] + 1) * ($invmaskarray[2] + 1) - 2
	   
	  history ("IP Address: " & $ip & " Subnet Mask: " & $netmask & " Wildcard: " & $invmask & " Broadcast Address: " & $broadcastadd & " Subnet Address: " & $subnetadd & " IP Range: " & $iprange & " Hosts: " & $hosts)
	  Return $broadcastadd
		 
   
   EndFunc


   ; Validation of IP address
   Func _IsValidIP($sIP)
	   If StringRegExp($sIP, "(?:(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])(\.)){3}(?:(25[0-5]$|2[0-4]\d$|1\d{2}$|[1-9]\d$|\d$))") Then Return 1
	   Return 0
   EndFunc


   ;
   ; Client/Server functions
   ;


   ; Resolve client IP address. Autoit example function
   Func SocketToIP($SHOCKET)
	   Local $sockaddr, $aRet

	   $sockaddr = DllStructCreate("short;ushort;uint;char[8]")

	   $aRet = DllCall("Ws2_32.dll", "int", "getpeername", "int", $SHOCKET, _
			   "ptr", DllStructGetPtr($sockaddr), "int*", DllStructGetSize($sockaddr))
	   If Not @error And $aRet[0] = 0 Then
		   $aRet = DllCall("Ws2_32.dll", "str", "inet_ntoa", "int", DllStructGetData($sockaddr, 3))
		   If Not @error Then $aRet = $aRet[0]
	   Else
		   $aRet = 0
	   EndIf

	   $sockaddr = 0

	   Return $aRet
   EndFunc   


   ; Start TCP server on IP:port
   Func StartTCPServer($ip, $port)
	  
	  history ("Starting TCP server....." & $ip)
	  TCPStartup ()
	  Local $socket = TCPListen($ip, $port)
	  If @error <> 0 Then 
	  history ("Fail to start TCP :" & $socket)
	  Else
	  history ("Started TCP server on IP - " & $ip & " port:" & $port & " Socket ID:" & $socket)
	  Return $socket
	  EndIf
   
   EndFunc

   ; Stop TCP server
   Func StopTCPServer($socket)
	  Sleep(1000)
	  local $t=TCPCloseSocket($socket)
	  history ("Try to close main TCP socket - " & $t)
	  If @error <> 0 Then
	  Else
	  $t=TCPShutdown()
	  history ("TCP Service off - " & $t)
	  EndIf
   
   EndFunc
 
   ; Send data to ip
   Func SendData ($ip, $dataS, $port)
	  history ("Sending network data")
	  TCPStartup()
	  Local $connexion = TCPConnect($ip, $port)
	  If @error <> 0 Then 
	  history ("Fail to start TCP :" & $connexion)
	  SendData ($ip, $dataS, $port)
	  Else
	  history ("To IP: " & $ip & " port:" & $port & ". Data | " & $dataS & " | Socket ID:" & $connexion)
			
			; console
			If $serverconsole==1 Then
			   GUICtrlSetData($console, $ip & " <-- Send: " & $dataS & @CRLF & GUICtrlRead($console))
			EndIf
			;
			
	  $res = TCPSend($connexion, StringToBinary($dataS, 4))
	  history ("Bytes sent " & $res)
	  Sleep(500)
	  local $t=TCPCloseSocket($connexion)
	  history ("Closing connection - " & $t)
	  $t=TCPShutdown()
	  history ("TCP Service off - " & $t)
	  Sleep(500)
	  EndIf
   EndFunc
 
 
   ; Recieve data from Network. Loop function
   Func RecieveData ($socket)
   history ("Start data recieving")
	 
	  Do
		 Local $ConnectedSocket = TCPAccept($socket)
		 
		 If $ConnectedSocket >= 0 Then
		  
			local $clientIP = SocketToIP($ConnectedSocket)
			history ("Client connected. IP: " & $clientIP)
			
			   If $serverconsole==1 Then
			   GUICtrlSetData($console, $clientIP & " connecting ... " & @CRLF & GUICtrlRead($console))
			   EndIf
		 
		 EndIf
			
			; Write to console
			If $serverconsole==1 Then
			$msg = GUIGetMsg()
			If $msg == $GUI_EVENT_CLOSE Then Exit
			EndIf
			;
			   
	  Until $ConnectedSocket <> -1
	  
	  		 
		 While 1
			
			
		 Local $dataR = TCPRecv($ConnectedSocket, 2048)
		 $dataR = BinaryToString($dataR, 4)
		 		
			If $dataR <> "" Then
			history ("Receiving packet...")
			
			   ; Write to console
			   If $serverconsole==1 Then
			   GUICtrlSetData($console, $clientIP & " --> Recieved: " & $dataR & @CRLF & GUICtrlRead($console))
			   EndIf
			   ;
			   
			Local $t= TCPCloseSocket($ConnectedSocket)
			history ("Close connection: " & $t)
			
			   if $dataR == "Exit" Then ; Stop recieving. Terminates connection
			   StopTCPServer($socket)
			   ExitLoop
			   EndIf
			
			ParseData($dataR,$clientIP)
			
			;;; Recursion - call to self
			Call ("RecieveData", $socket)
			ExitLoop
		    EndIf
	  
		 WEnd
 
   EndFunc
   
   
   ; Add to Firewall Exception. Need admin rights
   Func AddToFirewall ($appName, $applicationFullPath)
	  RunWait ('netsh advfirewall firewall add rule name="' & $appName &'" dir=in action=allow program="' & $applicationFullPath & '" enable=yes profile=any')
   EndFunc