#cs --------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         Sp1ker

 Script Function:
	
   The part of WakeUp Script Time Checker (WSTC)
   Server script. Waiting for connections and interact with clients

#ce --------------------------------------------------------------------

#include "Libs\libs.au3"
#include "Libs\head.au3"

Global $TimerStart

; PowerPlan vars
Local $tempfile=@HomeDrive & "\powercfg.txt" ; Temp file
If FileExists($tempfile)==1 Then FileDelete($tempfile) ; Check if file exists
Local $OldGUID=IniRead($inifile, "PowerPlan", "Old", "")
Local $NewGUID=IniRead($inifile, "PowerPlan", "New", "")

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
	  
	  ElseIf $GUID==$OldGUID Then
	  
	  history ("Found that old powerplan enabled  — " & $GUID)
	  
	  ShellExecuteWait('cmd.exe', '/c powercfg /SETACTIVE ' & $NewGUID)
	  
	  history ("Enabling powerplan — " & $NewGUID)
	  
	  EndIf


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