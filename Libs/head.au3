#cs --------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         Sp1ker

 Script Function:

   The part of WakeUp Script Time Checker (WSTC)
  It contains the beginning of each script

#ce --------------------------------------------------------------------

history ("Program started")
history ("Work directory � " & @ScriptDir)
;;;; Admin checkin ;;;;
; #RequireAdmin - Didn`t test yet
If IsAdmin()==0 Then
   MsgBox(0, "", "��� ������� ��������� ���������� ����� ��������������")
   history ("Admin check failed")
   Exit
Else
   history ("Admin check passed")
EndIf
;;;;

; Systeminfo
history ("Run on system: " & $osversion & "(" & @OSBuild & ") " & $osarch & " " & "Language" & " (" & $oslang & ") [0419=Rus 0409=En]"  & " autoitX64 - " & @AutoItX64 )
;

;;;; Windows version check ;;;;
If $osversion=="WIN_7" Or $osversion=="WIN_8" Or $osversion=="WIN_VISTA" Then
   history ("OS version check passed")
Else
   MsgBox(0, "", "��� ������� ��������� ���������� ������������ ������� Windows Vista/7/8")
   history ("OS version check failed")
   Exit
EndIf
;;;

;;;; Detect Client/Server install ;;;;

If FileExists($inifile)==1 Then

   $ScriptInstalled=1
   history ("INI file found � " & $inifile)
   If FileExists($ScriptFolder & "\" & $WakeClient) Then $ScriptInstalledType="Client"
   If FileExists($ScriptFolder & "\" & $WakeServer) Then $ScriptInstalledType="Server"
   history ("Detected type - " & $ScriptInstalledType)

Else

   $ScriptInstalled=0
   history ("INI file not found, use default vars")
   $ScriptInstalledType="Script"

EndIf




;;;
;;; Tray settings
;;;
WinMinimizeAll()
#NoTrayIcon
Opt("TrayIconDebug",$linedebug)
Opt("TrayOnEventMode", 1)
Opt("TrayMenuMode", 0) ; Default tray menu items (Script Paused/Exit) will be shown.
Opt("TrayAutoPause", 0) ; Autopause disabled
TraySetOnEvent($TRAY_EVENT_PRIMARYDOUBLE, "OpenLog") ; Function called when doubleclicked on tray icon
TraySetIcon(@Scriptname) ; Sets tray icon
TraySetState()