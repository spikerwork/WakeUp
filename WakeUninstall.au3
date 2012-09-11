#cs --------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         Sp1ker

 Script Function:

   The part of WakeUp Script Time Checker (WSTC)
   Uninstall Script. Deletes all.

#ce --------------------------------------------------------------------
#Region AutoIt3Wrapper directives section

#AutoIt3Wrapper_Run_AU3Check=n

#Endregion

#include "Libs\libs.au3"
#include "Libs\head.au3"

If FileExists($ScriptFolder & "\" & $WakeClient)==1 Then FileDelete($ScriptFolder & "\" & $WakeClient)
If FileExists($ScriptFolder & "\" & $WakePrepare)==1 Then FileDelete($ScriptFolder & "\" & $WakePrepare)
If FileExists($ScriptFolder & "\" & $WakeServer)==1 Then FileDelete($ScriptFolder & "\" & $WakeServer)
If FileExists($ScriptFolder & "\" & $WakeDaemon)==1 Then FileDelete($ScriptFolder & "\" & $WakeDaemon)
If FileExists($ScriptFolder & "\" & $WakeInstall)==1 Then FileDelete($ScriptFolder & "\" & $WakeInstall)
If FileExists($inifile)==1 Then FileDelete($inifile)
If FileExists($resultini)==1 Then FileDelete($resultini)

MsgBox(0,"Unistall succesful","WakeScript has removed", 5)
;@ProgramsCommonDir
_SelfDelete()

#include "Libs\foot.au3"