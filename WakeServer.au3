#cs --------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author: Sp1ker (spiker@pmpc.ru)
 Program: WakeUp Script Time Checker (WSTC)
 Site: https://github.com/spikerwork/WakeUp

 Script Function:

   The part of WakeUp Script Time Checker (WSTC)
   Server script. Waiting for connections and interact with clients

#ce --------------------------------------------------------------------

#Region AutoIt3Wrapper directives section

#AutoIt3Wrapper_Compile_both=n
#AutoIt3Wrapper_Icon=Alert.ico
#AutoIt3Wrapper_Res_Comment="Wake Server"
#AutoIt3Wrapper_Res_Description="WakeUp Script Time Checker (WSTC)"
#AutoIt3Wrapper_Res_Fileversion=0.3.5.53
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=y
#AutoIt3Wrapper_Res_Field=ProductName|WakeUp Script Time Checker
#AutoIt3Wrapper_Res_Field=ProductVersion|0.3.x.0
#AutoIt3Wrapper_Res_Field=OriginalFilename|WakeServer.au3
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Res_Language=2057
#AutoIt3Wrapper_Res_LegalCopyright=Sp1ker (spiker@pmpc.ru)
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator

#Endregion

#include "Libs\libs.au3"
#include "Libs\head.au3"

; Check active powerplan
If FileExists($tempfile)==1 Then FileDelete($tempfile) ; Check if file exists

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

	  ElseIf $GUID==$OldGUID Then

	  history ("Found that old powerplan enabled  — " & $GUID)

	  ShellExecuteWait('cmd.exe', '/c powercfg /SETACTIVE ' & $NewGUID)

	  history ("Enabling powerplan — " & $NewGUID)

	  EndIf

; Main functions of server

$socket = StartTCPServer($ServerIP,$TCPport)

; console enable
If $serverconsole==1 Then
Opt("GUICoordMode", 1)
$gui=GUICreate("Server (IP: " & $ServerIP & ")", 400, 300)
$console = GUICtrlCreateEdit("", 10, 10, 380, 280)
GUISetState()
EndIf

RecieveData ($socket)

; console enable
If $serverconsole==1 Then
GUIDelete($gui)
EndIf


#include "Libs\foot.au3"