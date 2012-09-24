#cs --------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author: Sp1ker (spiker@pmpc.ru)
 Program: WakeUp Script Time Checker (WSTC)
 Site: https://github.com/spikerwork/WakeUp

 Script Function:

   The part of WakeUp Script Time Checker (WSTC)
   Main installer. Includes all nessasary files

#ce --------------------------------------------------------------------

#Region AutoIt3Wrapper directives section

#AutoIt3Wrapper_Compile_both=n
#AutoIt3Wrapper_Icon=Alert.ico
#AutoIt3Wrapper_Res_Field=PreRelease|1
#AutoIt3Wrapper_Res_Description="WakeUp Script Time Checker (WSTC)"
#AutoIt3Wrapper_Res_Fileversion=0.3.5.80
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=y
#AutoIt3Wrapper_Res_Field=ProductName|WakeUp Script Time Checker
#AutoIt3Wrapper_Res_Field=ProductVersion|0.3.x.0
#AutoIt3Wrapper_Res_Field=OriginalFilename|WakeInstall.au3
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Res_Language=2057
#AutoIt3Wrapper_Res_LegalCopyright=Sp1ker (spiker@pmpc.ru)
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator

#Endregion

#include "Libs\libs.au3"
$linedebug=0
FileDelete($logfile)
#include "Libs\head.au3"

history ("Starting install...")

;;; Local Vars ;;;

Local $pausetime=5

;;; Form

Local $FormWidth=300
Local $FormHeight=200

;;; Empty

Local $Button_1
Local $Button_2
Local $Button_3
Local $Button_4
Local $F_inst
Local $F_log
Local $F_debug
Local $adapters=0
Local $t=0
Local $FilesInstallArray[1]
Local $res

;;; Network Check

Local $ipdetails=_IPDetail() ; Gather information of network adapters

While $t <= UBound($ipdetails, 2)-1

	if $ipdetails[0][$t]<>"" Then $adapters+=1
	$t+=1

WEnd

If $adapters==0 Then
	MsgBox(0, "Warning.", "Network adapters not found! Enable them and run script again.")
	history ("Network adapters not found! Enable them and run script again. Installation canceled")
	Exit
EndIf

; Help file install
If FileInstall("help.txt", @TempDir & "\" & $helpfile, 1)<>0 Then
history ("File " & $helpfile & " is copied successfully to " & @TempDir & "\" & $helpfile)
Else
history ("File " & $helpfile & " is not copied to" & @TempDir & "\" & $helpfile)
EndIf

; Creating main GUI
$mainGui=GuiCreate("Install WakeScript (WSTC)", $FormWidth,$FormHeight)
GUISetHelp(@ComSpec & ' /C start ' & @TempDir & "\" & $helpfile) ; Display Help file
Opt("GUICoordMode", 1)

GuiCtrlCreateLabel("Press F1 for help", 145, 0, 150, 15, $SS_RIGHT)

$Button_1 = GUICtrlCreateButton("Install WakeScript", 80, 30, 150, 40)
$F_inst=GUICtrlCreateCheckbox("Clean install ", 40, 80, 100, 20)
$F_log=GUICtrlCreateCheckbox("Log ", 140, 80, 50, 20)
$F_debug=GUICtrlCreateCheckbox("Debug ", 190, 80, 120, 20)
$Button_2 = GUICtrlCreateButton("Install BootTime", 80, 110, 150, 40)
GuiCtrlCreateLabel("(Old version of script)", 93, 155, 150, 20)

; Check installed version of script
GUICtrlSetState ($F_log, $GUI_CHECKED )
GUICtrlSetState ($F_debug, $GUI_UNCHECKED )

If $ScriptInstalled==0 Then
GUICtrlSetState ($F_inst, $GUI_DISABLE )
ElseIf $ScriptInstalled==1 Then
GUICtrlSetState ($F_inst, $GUI_ENABLE )
GUICtrlSetState ($F_inst, $GUI_CHECKED )
EndIf
GUISwitch($mainGui)
GUISetState ()

; Main GUI cycle

While 1

	$msg = GUIGetMsg()

	Select

	; Check log option

	Case $msg == $F_log

	If BitAnd(GUICtrlRead($F_log),$GUI_UNCHECKED) = $GUI_UNCHECKED Then
	GUICtrlSetState ($F_debug, $GUI_UNCHECKED )
	GUICtrlSetState ($F_debug, $GUI_DISABLE )
	$linedebug=0
	$log=0
	ElseIf BitAnd(GUICtrlRead($F_log),$GUI_CHECKED) = $GUI_CHECKED Then
	GUICtrlSetState ($F_debug, $GUI_ENABLE )
	$log=1
	EndIf

	;
	;
	; Install Server/Client
	;
	;

	Case $msg == $Button_1

	; Install Server/Client
	history ("Choosed option *Install Server/Client* " & $Button_1)

	GUISetState(@SW_HIDE, $mainGui)

	; Clear old files if they present

	If BitAnd(GUICtrlRead($F_debug),$GUI_CHECKED) = $GUI_CHECKED Then $linedebug=1
	If BitAnd(GUICtrlRead($F_debug),$GUI_UNCHECKED) = $GUI_UNCHECKED Then $linedebug=0
	If BitAnd(GUICtrlRead($F_log),$GUI_UNCHECKED) = $GUI_UNCHECKED Then $log=0
	If BitAnd(GUICtrlRead($F_log),$GUI_CHECKED) = $GUI_CHECKED Then $log=1


	If BitAnd(GUICtrlRead($F_inst),$GUI_CHECKED) = $GUI_CHECKED Then

		history ("Clearing folder " & $ScriptFolder)

		$t=0

		ProgressOn("Delete old exe files", "Deleting files", "0 percent")

		While $t <= Ubound($FilesArray)-1


			If FileExists($ScriptFolder & "\" & $FilesArray[$t])==1 Then

				$res=FileDelete($ScriptFolder & "\" & $FilesArray[$t])
				ProgressSet($t*10, $t*10 & " percent", $FilesArray[$t])
				Sleep(500)
				history ("File " & $FilesArray[$t] & " deleted=" & $res)

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

		history ("Delete other old files")

		If FileExists($inifile)==1 Then FileDelete($inifile)
		$t+=1
		ProgressSet($t*10, $t*10 & " percent", $inifile)
		Sleep(500)

		If FileExists($resultini)==1 Then FileDelete($resultini)
		$t+=1
		ProgressSet($t*10, $t*10 & " percent", $resultini)
		Sleep(500)

		If FileExists($timeini)==1 Then FileDelete($timeini)
		$t+=1
		ProgressSet($t*10, $t*10 & " percent", $timeini)
		Sleep(500)

		If FileExists($tempfile)==1 Then FileDelete($tempfile)
		$t+=1
		ProgressSet($t*10, $t*10 & " percent", $tempfile)
		Sleep(500)

		history ("Delete old files from " & @ProgramsCommonDir)

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

		history ("Clear all old log files")

		$t+=1
		ProgressSet($t*10, $t*10 & " percent", "Log files")
		Sleep(500)

		If $log==1 Then FileCopy($logfile, $newresultfile)
		Sleep(500)
		FileDelete($ScriptFolder & "\*.txt")
		If $log==1 Then FileCopy($newresultfile, $logfile)
		ProgressSet($t*10, $t*10 & " percent", "Temp files")

		; Remove programs from firewall
		history ("Remove firewall rules")
		ProgressSet($t*10, $t*10 & " percent", "Remove firewall rules")
		AddToFirewall($WakeClient, $ScriptFolder & "\" & $WakeClient,0)
		AddToFirewall($WakeServer, $ScriptFolder & "\" & $WakeServer,0)
		AddToFirewall($WakeDaemon, $ScriptFolder & "\" & $WakeDaemon,0)

		FileDelete($newresultfile)


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

		ProgressSet(100, "Done", "Complete")
		Sleep(500)
		ProgressOff()

    EndIf

	$destr=GUIDelete($mainGui)

	history ("Install main files")

	; Install all files
	IniWrite($inifile, "All", "Log", $log)
	IniWrite($inifile, "All", "LineDebug", $linedebug)

	ProgressOn("Install", "Copying files", "0 percent")

	$FilesInstallArray[0]=FileCopy(@ScriptFullPath,  $ScriptFolder, 1)
	$t=0
	ProgressSet($t*10, $t*10 & " percent", @ScriptName)
	Sleep(500)
	$t=_ArrayAdd($FilesInstallArray, FileInstall("WakeUninstall.exe", $ScriptFolder & "\" & $WakeUninstall))
	ProgressSet($t*10, $t*10 & " percent", $WakeUninstall)
	Sleep(500)
	$t=_ArrayAdd($FilesInstallArray, FileInstall("WakePrepare.exe", $ScriptFolder & "\" & $WakePrepare))
	ProgressSet($t*10, $t*10 & " percent", $WakePrepare)
	Sleep(500)
	$t=_ArrayAdd($FilesInstallArray, FileInstall("WakeServer.exe", $ScriptFolder & "\" & $WakeServer))
	ProgressSet($t*10, $t*10 & " percent", $WakeServer)
	Sleep(500)
	$t=_ArrayAdd($FilesInstallArray, FileInstall("WakeClient.exe", $ScriptFolder & "\" & $WakeClient))
	ProgressSet($t*10, $t*10 & " percent", $WakeClient)
	Sleep(500)
	$t=_ArrayAdd($FilesInstallArray, FileInstall("WakeStart.exe", $ScriptFolder & "\" & $WakeStart))
	ProgressSet($t*10, $t*10 & " percent", $WakeStart)
	Sleep(500)
	$t=_ArrayAdd($FilesInstallArray, FileInstall("WakeDaemon.exe", $ScriptFolder & "\" & $WakeDaemon))
	ProgressSet($t*10, $t*10 & " percent", $WakeDaemon)
	Sleep(500)
	$t=_ArrayAdd($FilesInstallArray, FileMove(@TempDir & "\" & $helpfile, $ScriptFolder & "\" & $helpfile,1))
	ProgressSet($t*10, $t*10 & " percent", $helpfile)
	Sleep(500)

	ProgressSet(100, "Done", "Complete")
	Sleep(500)
	ProgressOff()

	; Check file install
	$t=0
	While $t <= Ubound($FilesInstallArray)-1

		If $FilesInstallArray[$t]==1 Then
		   history ("Copied file " & $FilesArray[$t])
		   $t=$t+1
		Else

		   MsgBox(0, "Sad News!", "Some files can`t be installed. See log for details")
		   history ("File missed. Number - " & $t+1 & ". Sequence of file install : WakeInstall, WakeUninstall.exe, WakePrepare.exe, WakeServer.exe, WakeClient.exe, WakeStart.exe, WakeDaemon.exe, help.txt")

		ExitLoop(2)
		EndIf

	WEnd


	history ("Create program files directory")

	; Start Menu install
	DirCreate(@ProgramsCommonDir & "\" & $ScriptName)

	FileCreateShortcut($ScriptFolder & "\" & $WakeInstall, @ProgramsCommonDir & "\" & $ScriptName & "\WakeInstall.lnk", $ScriptFolder)
	FileCreateShortcut($ScriptFolder & "\" & $WakeStart, @ProgramsCommonDir & "\" & $ScriptName & "\WakeStart.lnk", $ScriptFolder)
	FileCreateShortcut($ScriptFolder & "\" & $WakeUninstall, @ProgramsCommonDir & "\" & $ScriptName & "\WakeUninstall.lnk", $ScriptFolder)

	PauseTime($pausetime)

	MsgBox(0,"Good news!", "Installation of WakeScript completed. Setup`ll starts WakeStart in 5 seconds", 5)

	Run($ScriptFolder & "\" & $WakeStart, $ScriptFolder)

	ExitLoop

	;;;;; End install ;;;;;


	;
	;
	; Install BootTime
	;
	;

   Case $msg == $Button_2
   ; Install BootTime (Old script for test)

   history ("Choosed option *Install BootTime* " & $Button_2)

	  If FileExists(@TempDir & "\" & $WakeBT)==1 Then FileDelete(@TempDir & "\" & $WakeBT) ; Check if file exists
	  If FileInstall("BT.exe", @TempDir & "\" & $WakeBT)<>0 Then
		 history ("File " & $WakeBT & " is copied successfully to " & @TempDir & "\" & $WakeBT)
		 GUISetState(@SW_HIDE, $mainGui)
		 $destr=GUIDelete($mainGui)
		 history ("Main GUI destroyed — " & $destr)
		 PauseTime($pausetime)
		 history ("Starting process — " & @TempDir & "\" & $WakeBT)
		 FileDelete(@TempDir & "\" & $helpfile)
		 Run(@TempDir & "\" & $WakeBT, @TempDir)
		 ExitLoop
	  Else
		 history ("File " & $WakeBT & " is not copied to " & @TempDir & "\" & $WakeBT)
	 EndIf

	;;;;; End BootTime install ;;;;;

   Case $msg == $GUI_EVENT_CLOSE
   ; Exit installer

	  $destr=GUIDelete($mainGui)
	  history ("Main GUI destroyed — " & $destr)
	  ; Clean temp files
	  FileDelete(@TempDir & "\" & $helpfile)
	  history ("Installation canceled")
	  ExitLoop

   EndSelect


WEnd

#include "Libs\foot.au3"