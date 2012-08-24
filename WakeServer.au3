#include "Libs\libs.au3"
#include "Libs\head.au3"
Local $ipdetails=_IPDetail()

$socket = StartTCPServer($ServerIP,$TCPport)

Opt("GUICoordMode", 1)
$gui=GUICreate("Server (IP: " & $ServerIP & ")", 400, 300)
$console = GUICtrlCreateEdit("", 10, 10, 380, 280)
GUISetState()

RecieveData ($socket)

GUIDelete($gui)
#include "Libs\foot.au3"