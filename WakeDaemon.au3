#cs --------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         Sp1ker

 Script Function:
	
   The part of WakeUp Script Time Checker (WSTC)
   Launches Activity Daemon, that can get the idle time of testing PC

#ce --------------------------------------------------------------------

#include "Libs\libs.au3"
#include "Libs\head.au3"

If $CmdLine[0] > 0 Then

$runs_all=IniRead($resultini, "Client", "TestRepeat", $testrepeats)
$runs_left=IniRead($resultini, "Runs", "Left", 0)
$run_num=$runs_all-$runs_left
$current_run="Current run #" & $run_num

; Need some addon
$war=ActivityDaemon()
SendData($ServerIP, "ToServer|" & $CMDLine[1] & "|" & $run_num & "|" & $war, $TCPport)
PauseTime($ClientPause)

$socket = StartTCPServer($Client_IP,$TCPport+1)
RecieveData ($socket)
	  
Run($ScriptFolder & "\" & $WakeClient, $ScriptFolder)

 
Else
history ("Smth wrong with command line to this script. No args!")
Exit
EndIf

		 
#include "Libs\foot.au3"

