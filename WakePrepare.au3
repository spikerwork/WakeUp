#cs --------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         Sp1ker

 Script Function:
	Install main scripts on PC

#ce ---

#include "Libs\libs.au3"
#include "Libs\head.au3"

; Setting power options
Local $Data = _WinAPI_GetSystemPowerStatus()

   If $Data[1]=128 Then
	  
	  history ("Battery not detected Ч " & $Data[1])
	  $powerplan=$Power_Desktop
	  If FileExists($ScriptFolder & "\" & $Power_Desktop)==1 Then FileDelete($ScriptFolder & "\" & $Power_Desktop) ; Check if file exists

	  If FileInstall("PowerFiles\Desktop.pow", $ScriptFolder & "\" & $Power_Desktop)<>0 Then
			
		 history ("File " & $Power_Desktop & " is copied successfully to " & $ScriptFolder)
		 
	  
	  Else
	  
		 history ("File " & $Power_Desktop & " is not copied to " & $ScriptFolder )
		 Exit
	  
	  Endif	
	  
   Else
	  
   
	  history ("Battery detected Ч " & $Data[1])
	  $powerplan=$Power_Notebook
	  If FileExists($ScriptFolder & "\" & $Power_Notebook)==1 Then FileDelete($ScriptFolder & "\" & $Power_Notebook) ; Check if file exists
	  
	  If FileInstall("PowerFiles\Notebook.pow", $ScriptFolder & "\" & $Power_Notebook)<>0 Then
			
		 history ("File " & $Power_Notebook & " is copied successfully to " & $ScriptFolder)
	  
	  Else
   
		 history ("File " & $Power_Notebook & " is not copied to " & $ScriptFolder )
		 Exit
	  
	  EndIf
	  
	  
   EndIf

Local $tempfile=@HomeDrive & "\powercfg.txt"

If FileExists($tempfile)==1 Then FileDelete($tempfile) ; Check if file exists

	  
	  ShellExecuteWait('cmd.exe', '/c powercfg -IMPORT ' & $ScriptFolder & "\" & $powerplan & '  | find /I "GUID" > ' & $tempfile)
 
	  $file=FileOpen($tempfile, 0)
	  $line = FileReadLine($file)
	  $result = StringInStr($line, ":")
	  $GUID=StringTrimLeft($line,$result+1)
	  
	  FileClose($file)
	  FileDelete($tempfile)

	  ShellExecuteWait('cmd.exe', '/c powercfg /SETACTIVE ' & $GUID)
	  
	  history ("New power plan enabled Ч " & $GUID)
	  
If FileExists($ScriptFolder & "\" & $Power_Desktop)==1 Then FileDelete($ScriptFolder & "\" & $Power_Desktop) ; Check if file exists
If FileExists($ScriptFolder & "\" & $Power_Notebook)==1 Then FileDelete($ScriptFolder & "\" & $Power_Notebook) ; Check if file exists

   
;отключение экранной заставки
RegWrite("HKCU\Control Panel\Desktop", "ScreenSaveActive", "REG_SZ", 0)

;ќтключение firewall
;RunWait("SC stop MpsSvc")

If $CmdLine[0] > 0 Then
   
   If $CMDLine[1] == "Server" Then
   history ("Detected Server install Ч " & $CMDLine[1])
   
   _FirewallException(1, $WakeServer, $ScriptFolder & "\" & $WakeServer)
   
   ;Run($ScriptFolder & "\" & $WakeServer, $ScriptFolder)
   FileCreateShortcut ($ScriptFolder & "\" & $WakeServer, @StartupCommonDir & "\WakeServer.lnk")
	
   ElseIf $CMDLine[1] == "Client" Then
   history ("Detected Client install Ч " & $CMDLine[1])
	  
   _FirewallException(1, $WakeClient, $ScriptFolder & "\" & $WakeClient)
   
   ;Run($ScriptFolder & "\" & $WakeClient, $ScriptFolder)
   FileCreateShortcut ($ScriptFolder & "\" & $WakeClient, @StartupCommonDir & "\WakeClient.lnk")
		 
   EndIf

EndIf


MsgBox(0, "Good news!", "¬се прошло успешно. ѕерезагрузка через 5 секунд", 5)
halt("reboot")

#include "Libs\foot.au3"