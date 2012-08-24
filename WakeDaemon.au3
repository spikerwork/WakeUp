#include "Libs\libs.au3"
#include "Libs\head.au3"

$runs_all=IniRead($inifile, "Client", "TestRepeat", 5)+1
$runs_left=IniRead($resultini, "Runs", "Left", "")
$run=$runs_all-$runs_left


If $CmdLine[0] > 0 Then
   
   If $CMDLine[1] == "Sleep" Then
	  Local $parametr = "SleepStop"
	  
   ElseIf $CMDLine[1] == "Hibernate" Then
	  Local $parametr = "HibernateStop"
	  
   ElseIf $CMDLine[1] == "Halt" Then
	  Local $parametr = "HaltStop"
	  
   EndIf
Else
history ("Smth wrong with command line — ")
Exit
EndIf


ActivityDaemon()
SendData($ServerIP, "ToServer|" & $parametr & "|" & $run , $TCPport)

#include "Libs\foot.au3"

