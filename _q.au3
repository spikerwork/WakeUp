#comments-start
Routine to extract the IP address and other useful information from a PC. The PC must be able to run ipconfig in dos (so no Win 95). Also There must be a C:\
Duh!

#comments-end
 
$ip = @IPAddress1
RunWait(@ComSpec & " /c ipconfig > " & "c:\ipconfig.txt", "", @SW_HIDE)
$parse = FileReadLine("c:\ipconfig.txt", 1)
$submasktext = StringLeft(StringStripWS($parse, 8), 11)
$netmask = StringStripWS(StringTrimLeft($parse, StringInStr($parse, "Subnet Mask") + 35), 8)
$linecount = 1
 
;Find Subnet Mask statement in txt file if not on line 1

While $submasktext <> "SubnetMask."
 $parse = FileReadLine("C:\ipconfig.txt", $linecount)
 If @error = -1 Then ExitLoop
 $submasktext = StringLeft(StringStripWS($parse, 8), 11)
 $netmask = StringStripWS(StringTrimLeft($parse, StringInStr($parse, "Subnet Mask") + 35), 8)
 $linecount = $linecount + 1
Wend

$ip="10.0.0.1"
$netmask="255.255.252.0"

$iparray = StringSplit($ip, ".")
$netmaskarray = StringSplit($netmask, ".")
;MsgBox(0,"",$netmask)
 
Dim $subnetaddarray[5]
Dim $invmaskarray[5]
Dim $broadcastaddarray[5]
 
For $i = 1 To $iparray[0]
   ;MsgBox(0,$netmaskarray[$i],$iparray[$i])
   $subnetaddarray[$i] = BitAND($iparray[$i], $netmaskarray[$i])
   $invmaskarray[$i] = BitNOT($netmaskarray[$i] - 256)
   $broadcastaddarray[$i] = BitOR($subnetaddarray[$i], $invmaskarray[$i])
Next
 
$broadcastadd = $broadcastaddarray[1] & "." & $broadcastaddarray[2] & "." & $broadcastaddarray[3] & "." & $broadcastaddarray[4]
 
$subnetadd = $subnetaddarray[1] & "." & $subnetaddarray[2] & "." & $subnetaddarray[3] & "." & $subnetaddarray[4]
 
$invmask = $invmaskarray[1] & "." & $invmaskarray[2] & "." & $invmaskarray[3] & "." & $invmaskarray[4]
 
$iprange = $subnetaddarray[1] & "." & $subnetaddarray[2] & "." & $subnetaddarray[3] & "." & $subnetaddarray[4] + 1 & "-" & $broadcastaddarray[1] & "." & $broadcastaddarray[2] & "." & $broadcastaddarray[3] & "." & $broadcastaddarray[4] - 1
 
$hosts = ($invmaskarray[4] + 1) * ($invmaskarray[3] + 1) * ($invmaskarray[2] + 1) - 2
 
MsgBox(0, "IP Info", "IP Address: " & $ip & @CRLF & "Subnet Mask: " & $netmask & @CRLF & "Wildcard: " & $invmask & @CRLF & "Broadcast Address: " & $broadcastadd & @CRLF & "Subnet Address: " & $subnetadd & @CRLF & "IP Range: " & $iprange & @CRLF & "Hosts: " & $hosts & @CRLF & "This PC's Name: " & @ComputerName)
 
If FileExists("c:\ipconfig.txt") Then
   FileDelete("c:\ipconfig.txt")
EndIf