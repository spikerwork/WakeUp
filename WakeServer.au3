#cs --------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         Sp1ker

 Script Function:
	
   The part of WakeUp Script Time Checker (WSTC)
   Server script. Waiting for connections and interact with clients

#ce --------------------------------------------------------------------

#include "Libs\libs.au3"
#include "Libs\head.au3"

Local $ipdetails=_IPDetail()


Global $TimerStart

$socket = StartTCPServer($ServerIP,$TCPport)

; console enable
If $serverconsole==1 Then
Opt("GUICoordMode", 1)
$gui=GUICreate("Server (IP: " & $ServerIP & ")", 400, 300)
$console = GUICtrlCreateEdit("", 10, 10, 380, 280)
GUISetState()
EndIf

RecieveData ($socket)

; console enable
If $serverconsole==1 Then
GUIDelete($gui)
EndIf


#include "Libs\foot.au3"