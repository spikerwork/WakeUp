#cs --------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         Sp1ker

 Script Function:
	
   The part of WakeUp Script Time Checker (WSTC)
   Server script. Waiting for connections and interact with clients

#ce --------------------------------------------------------------------

#include "Libs\libs.au3"
#include "Libs\head.au3"

$GUID=1
$NewGUID=1
ShellExecuteWait('cmd.exe', '/c powercfg /SETACTIVE ' & $GUID)
ShellExecuteWait('cmd.exe', '/c powercfg -DELETE ' & $NewGUID)
			

;SendData($ServerIP, "ClientOff", $TCPport)
#include "Libs\foot.au3"