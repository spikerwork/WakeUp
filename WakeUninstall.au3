#cs --------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         Sp1ker

 Script Function:

   The part of WakeUp Script Time Checker (WSTC)
   Uninstall Script. Deletes all.

#ce --------------------------------------------------------------------
#Region AutoIt3Wrapper directives section

#AutoIt3Wrapper_Compile_both=n
#AutoIt3Wrapper_Res_Comment="Wake Install"
#AutoIt3Wrapper_Res_Description="WakeUp Script Time Checker (WSTC)"
#AutoIt3Wrapper_Res_Fileversion=0.2.0.9
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=y
#AutoIt3Wrapper_Res_Field=ProductName|WakeUp Script Time Checker
#AutoIt3Wrapper_Res_Field=ProductVersion|0.1.0.0
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Res_Language=2057
#AutoIt3Wrapper_Res_LegalCopyright=Sp1ker (spiker@pmpc.ru)
#AutoIt3Wrapper_res_requestedExecutionLevel=requireAdministrator

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
DirRemove(@ProgramsCommonDir & "\" & $ScriptName, 1)

If FileExists($tempfile)==1 Then FileDelete($tempfile) ; Check if file exists

	; Check active powerplan

	  ShellExecuteWait('cmd.exe', '/c powercfg GETACTIVESCHEME | find /I ":" > ' & $tempfile)

	  $file=FileOpen($tempfile, 0)
	  $line = FileReadLine($file)
	  $result = StringInStr($line, ":")
	  $GUID=StringTrimLeft($line,$result+1)
	  $result = StringInStr($GUID, " ")
	  $GUID=StringLeft($GUID,$result-1)

	  FileClose($file)
	  FileDelete($tempfile)

	  If $GUID==$NewGUID Then

	  history ("Found that new powerplan enabled  — " & $GUID)

	  ShellExecuteWait('cmd.exe', '/c powercfg /SETACTIVE ' & $OldGUID)

	  history ("Enabling previous powerplan — " & $OldGUID)

	  ElseIf $GUID==$OldGUID Then

	  history ("Found that previous powerplan enabled  — " & $GUID)

	  EndIf




MsgBox(0,"Unistall succesful","WakeScript has removed", 5)
;@ProgramsCommonDir
_SelfDelete()

#include "Libs\foot.au3"