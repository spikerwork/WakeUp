#cs --------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author: Sp1ker (spiker@pmpc.ru)
 Program: WakeUp Script Time Checker (WSTC)
 Site: https://github.com/spikerwork/WakeUp

 Script Function:

   The part of WakeUp Script Time Checker (WSTC)
   Launches Activity Daemon, that can get the idle time of testing PC

#ce --------------------------------------------------------------------

#Region AutoIt3Wrapper directives section

#AutoIt3Wrapper_Compile_both=n
#AutoIt3Wrapper_Icon=Alert.ico
#AutoIt3Wrapper_Res_Comment="Wake Daemon"
#AutoIt3Wrapper_Res_Description="WakeUp Script Time Checker (WSTC)"
#AutoIt3Wrapper_Res_Fileversion=0.3.5.58
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=y
#AutoIt3Wrapper_Res_Field=ProductName|WakeUp Script Time Checker
#AutoIt3Wrapper_Res_Field=ProductVersion|0.3.x.0
#AutoIt3Wrapper_Res_Field=OriginalFilename|WakeDaemon.au3
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Res_Language=2057
#AutoIt3Wrapper_Res_LegalCopyright=Sp1ker (spiker@pmpc.ru)
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator

#Endregion

#include "Libs\libs.au3"
#include "Libs\head.au3"

;;;; Timestamp ;;;;

If FileExists($timeini) Then FileDelete($timeini)
IniWrite($timeini, "Start", "Time", $ScriptStartTime)
history ("UnixTimeStamp " & $ScriptStartTime & ". Start — " & currenttime())


If $CmdLine[0] > 0 Then

$runs_all=IniRead($resultini, "Client", "TestRepeat", $testrepeats)
$runs_left=IniRead($resultini, "Runs", "Left", 0)
$run_num=$runs_all-$runs_left
$current_run="Current run #" & $run_num

$war=ActivityDaemon()
ToolTip($current_run, 2000, 0, @ScriptName, 2,4)
SendData($ServerIP, "ToServer|" & $CMDLine[1] & "|" & $run_num & "|" & $war, $TCPport)
PauseTime($ClientPause)

$socket = StartTCPServer($Client_IP,$TCPport+1)
RecieveData ($socket)

Run($ScriptFolder & "\" & $WakeClient, $ScriptFolder)


Else
history ("Smth wrong with command line to this script. No args!")
EndIf

If FileExists($timeini) Then FileDelete($timeini)

#include "Libs\foot.au3"

