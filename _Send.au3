#cs --------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         Sp1ker

 Script Function:
	
   The part of WakeUp Script Time Checker (WSTC)
   Server script. Waiting for connections and interact with clients

#ce --------------------------------------------------------------------

#include "Libs\libs.au3"
#include "Libs\head.au3"
SendData($ServerIP, "ClientOff", $TCPport)
#include "Libs\foot.au3"