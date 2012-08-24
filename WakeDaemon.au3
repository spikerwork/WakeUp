#include "Libs\libs.au3"
#include "Libs\head.au3"

If $CmdLine[0] > 0 Then

$runs_all=IniRead($inifile, "Client", "TestRepeat", 5)+1
$runs_left=IniRead($resultini, "Runs", "Left", "")
$run_num=$runs_all-$runs_left
$current_run="Current run #" & $run_num

$war=ActivityDaemon()
SendData($ServerIP, "ToServer|" & $CMDLine[1] & "|" & $run_num & "|" & $war, $TCPport)
PauseTime($ClientPause)

$socket = StartTCPServer($Client_IP,$TCPport+1)
RecieveData ($socket)
	  
Run($ScriptFolder & "\" & $WakeClient, $ScriptFolder)

 
Else
history ("Smth wrong with command line ")
Exit
EndIf

		 
#include "Libs\foot.au3"

