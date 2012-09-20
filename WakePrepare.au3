#cs --------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         Sp1ker

 Script Function:

   The part of WakeUp Script Time Checker (WSTC)
   Prepare script.

#ce --------------------------------------------------------------------

#Region AutoIt3Wrapper directives section

#AutoIt3Wrapper_Compile_both=n
#AutoIt3Wrapper_Res_Comment="Wake Prepare"
#AutoIt3Wrapper_Res_Description="WakeUp Script Time Checker (WSTC)"
#AutoIt3Wrapper_Res_Fileversion=0.3.0.26
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=y
#AutoIt3Wrapper_Res_Field=ProductName|WakeUp Script Time Checker
#AutoIt3Wrapper_Res_Field=ProductVersion|0.2.0.0
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Res_Language=2057
#AutoIt3Wrapper_Res_LegalCopyright=Sp1ker (spiker@pmpc.ru)
#AutoIt3Wrapper_res_requestedExecutionLevel=requireAdministrator
#AutoIt3Wrapper_Res_requestedExecutionLevel=highestAvailable

#Endregion
#include "Libs\libs.au3"
#include "Libs\head.au3"

; Setting power options
Local $Data = _WinAPI_GetSystemPowerStatus() ; Get battery information

   If $Data[1]=128 Then

	  history ("Battery not detected — " & $Data[1])
	  $powerplan=$Power_Desktop
	  If FileExists($ScriptFolder & "\" & $Power_Desktop)==1 Then FileDelete($ScriptFolder & "\" & $Power_Desktop) ; Check if file exists

	  If FileInstall("PowerFiles\Desktop.pow", $ScriptFolder & "\" & $Power_Desktop)<>0 Then

		 history ("File " & $Power_Desktop & " is copied successfully to " & $ScriptFolder)

	  Else

		 history ("File " & $Power_Desktop & " is not copied to " & $ScriptFolder )
		 Exit

	  Endif

   Else


	  history ("Battery detected — " & $Data[1])
	  $powerplan=$Power_Notebook
	  If FileExists($ScriptFolder & "\" & $Power_Notebook)==1 Then FileDelete($ScriptFolder & "\" & $Power_Notebook) ; Check if file exists

	  If FileInstall("PowerFiles\Notebook.pow", $ScriptFolder & "\" & $Power_Notebook)<>0 Then

		 history ("File " & $Power_Notebook & " is copied successfully to " & $ScriptFolder)

	  Else

		 history ("File " & $Power_Notebook & " is not copied to " & $ScriptFolder )
		 Exit

	  EndIf


   EndIf

IniWrite($inifile, "PowerPlan", "Type", $powerplan)

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

	  IniWrite($inifile, "PowerPlan", "Old", $GUID)
	  history ("Old power plan  — " & $GUID)

	  ShellExecuteWait('cmd.exe', '/c powercfg -IMPORT ' & $ScriptFolder & "\" & $powerplan & '  | find /I "GUID" > ' & $tempfile)

	  $file=FileOpen($tempfile, 0)
	  $line = FileReadLine($file)
	  $result = StringInStr($line, ":")
	  $GUID=StringTrimLeft($line,$result+1)

	  FileClose($file)
	  FileDelete($tempfile)

	  ShellExecuteWait('cmd.exe', '/c powercfg /SETACTIVE ' & $GUID)

	  IniWrite($inifile, "PowerPlan", "New", $GUID)
	  history ("New power plan enabled — " & $GUID)


If FileExists($ScriptFolder & "\" & $Power_Desktop)==1 Then FileDelete($ScriptFolder & "\" & $Power_Desktop) ; Check if file exists
If FileExists($ScriptFolder & "\" & $Power_Notebook)==1 Then FileDelete($ScriptFolder & "\" & $Power_Notebook) ; Check if file exists


; Turn off screensaver
RegWrite("HKCU\Control Panel\Desktop", "ScreenSaveActive", "REG_SZ", 0)

; Add to firewall exeptions
RunWait("SC start MpsSvc") ; Enable firewall

If $CmdLine[0] > 0 Then

   If $CMDLine[1] == "Server" Then
   history ("Detected Server install — " & $CMDLine[1])

   AddToFirewall($WakeServer, $ScriptFolder & "\" & $WakeServer)

   FileCreateShortcut ($ScriptFolder & "\" & $WakeServer, @StartupCommonDir & "\WakeServer.lnk")

   ElseIf $CMDLine[1] == "Client" Then
   history ("Detected Client install — " & $CMDLine[1])

   AddToFirewall($WakeClient, $ScriptFolder & "\" & $WakeClient)
   AddToFirewall($WakeDaemon, $ScriptFolder & "\" & $WakeDaemon)

   FileCreateShortcut ($ScriptFolder & "\" & $WakeClient, @StartupCommonDir & "\WakeClient.lnk")

   EndIf

EndIf


MsgBox(0, "Good news!", "Prepare finished. Restart in 5 seconds", 5)
halt("reboot")

#include "Libs\foot.au3"