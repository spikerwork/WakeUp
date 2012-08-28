#cs --------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         Sp1ker

 Script Function:
	
   The part of WakeUp Script Time Checker (WSTC)
   Server script. Waiting for connections and interact with clients

#ce --------------------------------------------------------------------

#include "Libs\libs.au3"
#include "Libs\head.au3"

Local $begin = TimerInit()
Sleep(3000)
Local $TimerD = TimerDiff($begin)
$TimerD=Round($TimerD/1000,2)
;If IsInt($seconds) Then $seconds&=".00"
   
MsgBox(0, "Time Difference", $seconds)


;SendData($ServerIP, "ClientOff", $TCPport)
#include "Libs\foot.au3"