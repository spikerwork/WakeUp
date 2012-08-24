#cs --------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         Sp1ker

 Script Function:
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
;;;

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
TraySetState()