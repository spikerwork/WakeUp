#cs --------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author: Sp1ker (spiker@pmpc.ru)
 Program: WakeUp Script Time Checker (WSTC)
 Site: https://github.com/spikerwork/WakeUp

 Script Function:

   The part of WakeUp Script Time Checker (WSTC)
   Uninstall Script. Deletes all.

#ce --------------------------------------------------------------------
#Region AutoIt3Wrapper directives section

#AutoIt3Wrapper_Compile_both=n
#AutoIt3Wrapper_Icon=Alert.ico
#AutoIt3Wrapper_Res_Comment="Wake Uninstall"
#AutoIt3Wrapper_Res_Description="WakeUp Script Time Checker (WSTC)"
#AutoIt3Wrapper_Res_Fileversion=0.3.5.62
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=y
#AutoIt3Wrapper_Res_Field=ProductName|WakeUp Script Time Checker
#AutoIt3Wrapper_Res_Field=ProductVersion|0.3.x.0
#AutoIt3Wrapper_Res_Field=OriginalFilename|WakeUninstall.au3
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Res_Language=2057
#AutoIt3Wrapper_Res_LegalCopyright=Sp1ker (spiker@pmpc.ru)
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator

#Endregion

#include "Libs\libs.au3"
#include "Libs\head.au3"

		$t=0
		ProgressOn("Delete old exe files", "Deleting files", "0 percent")

		While $t <= Ubound($FilesArray)-1

			If FileExists($ScriptFolder & "\" & $FilesArray[$t])==1 Then
				$res=FileDelete($ScriptFolder & "\" & $FilesArray[$t])
				history ("File " & $FilesArray[$t] & " deleted=" & $res)
				ProgressSet($t*10, $t*10 & " percent", $FilesArray[$t])
				Sleep(500)
			Else
				history ("File " & $FilesArray[$t] & " not found")
				ProgressSet($t*10, $t*10 & " percent", "File " & $FilesArray[$t] & " skipped")
				Sleep(500)
			EndIf

			$t+=1

		WEnd

		ProgressSet(100, "Done", "Complete")
		Sleep(500)
		ProgressOff()

		$t=1

		ProgressOn("Delete other old files", "Deleting files", "0 percent")

		If FileExists($inifile)==1 Then FileDelete($inifile)
		$t+=1
		ProgressSet($t*10, $t*10 & " percent", $inifile)
		Sleep(500)

		If FileExists($resultini)==1 Then FileDelete($resultini)
		$t+=1
		ProgressSet($t*10, $t*10 & " percent", $resultini)
		Sleep(500)

		If FileExists($ScriptFolder & "\" & $helpfile)==1 Then FileDelete($ScriptFolder & "\" & $helpfile)
		$t+=1
		ProgressSet($t*10, $t*10 & " percent", $helpfile)
		Sleep(500)

		DirRemove(@ProgramsCommonDir & "\" & $ScriptName, 1)
		$t+=1
		ProgressSet($t*10, $t*10 & " percent", "Folder " & $ScriptName)
		Sleep(500)

		If FileExists(@StartupCommonDir & "\WakeClient.lnk")==1 Then FileDelete(@StartupCommonDir & "\WakeClient.lnk")
		$t+=1
		ProgressSet($t*10, $t*10 & " percent", "WakeClient.lnk")
		Sleep(500)

		If FileExists(@StartupCommonDir & "\WakeDaemon.lnk")==1 Then FileDelete(@StartupCommonDir & "\WakeDaemon.lnk")
		$t+=1
		ProgressSet($t*10, $t*10 & " percent", "WakeDaemon.lnk")
		Sleep(500)

		If FileExists(@StartupCommonDir & "\WakeServer.lnk")==1 Then FileDelete(@StartupCommonDir & "\WakeServer.lnk")
		$t+=1
		ProgressSet($t*10, $t*10 & " percent", "WakeServer.lnk")
		Sleep(500)

		If FileExists($tempfile)==1 Then FileDelete($tempfile)
		$t+=1
		ProgressSet($t*10, $t*10 & " percent", $tempfile)
		Sleep(500)

		If FileExists($timeini)==1 Then FileDelete($timeini)
		$t+=1
		ProgressSet($t*10, $t*10 & " percent", $timeini)
		Sleep(500)

		ProgressSet(100, "Done", "Complete")
		Sleep(500)
		ProgressOff()

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

	  history ("Found that new powerplan enabled  - " & $GUID)

	  ShellExecuteWait('cmd.exe', '/c powercfg /SETACTIVE ' & $OldGUID)

	  history ("Enabling previous powerplan - " & $OldGUID)

	  ShellExecuteWait('cmd.exe', '/c powercfg /DELETE ' & $NewGUID)

	  history ("Remove powerplan - " & $NewGUID)

	  ElseIf $GUID==$OldGUID Then

	  history ("Found that previous powerplan enabled  - " & $GUID)

	  ShellExecuteWait('cmd.exe', '/c powercfg /DELETE ' & $NewGUID)

	  history ("Remove powerplan - " & $NewGUID)

	  EndIf

	; Remove programs from firewall
	AddToFirewall($WakeClient, $ScriptFolder & "\" & $WakeClient,0)
	AddToFirewall($WakeServer, $ScriptFolder & "\" & $WakeServer,0)
	AddToFirewall($WakeDaemon, $ScriptFolder & "\" & $WakeDaemon,0)

MsgBox(0,"Unistall succesful","WakeScript has removed", 5)

_SelfDelete() ; Delete this exe file

#include "Libs\foot.au3"