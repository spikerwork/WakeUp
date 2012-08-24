#cs ----------------------------------------------------------------------------

AutoIt Version: 3.3.8.1
 Author:         Sp1ker

 Script Function:
	The Part of Windows Boot time checker
 ----------------------------------------------------
#ce ----------------------------------------------------------------------------

#include "lib.au3"
WinMinimizeAll()
Opt("WinTitleMatchMode", 2)

Local $lastrun=0

; Load vars from ini
$firstrun=IniRead($mainini, $section_runs, "First Run", "")
$runs_all=IniRead($mainini, $section_runs, "All", "")
$runs_left=IniRead($mainini, $section_runs, "Left", "")
$run=$runs_all-$runs_left
If $runs_left==1 Then $lastrun=1
$current_run="Current run #" & $run


If $firstrun==1 Then 
ToolTip("»дет подготовка к запуску теста " & $ScriptName,2000,0 , "ѕервый запуск", 1,4)
			
PauseTime(15)

	  Local $t
	  While $t <= Ubound($RegistryArray)-1
	  RegWrite($RegistryArray[$t], "BootTime","REG_SZ", '"' & $testexe & '" ' & $RegistryArray[$t])
	  $t = $t + 1
	  WEnd
	  $t=0
	  
		 ; Remove first run
		 If RegRead($RegistryArray[0], "BT_result_parser")<>"" Then
		 RegDelete($RegistryArray[0], "BT_result_parser")
		 EndIf
		 FileDelete (@StartupCommonDir & "\BT_result_parser.lnk")
	   
		 ; Add links to Startups directory
		 FileCreateShortcut($testexe, @StartupCommonDir & "\boottime.lnk", @HomeDrive & "\", " StartupCommonDir")
		 FileCreateShortcut($testexe, @StartupDir & "\boottime.lnk", @HomeDrive & "\", " StartupDir")
		 FileCreateShortcut($daemon, @StartupDir & "\BTDaemon.lnk", @HomeDrive & "\", " StartupDir")
	  
	  IniWrite($mainini, $section_runs, "First Run", 0)
	  
	  MsgBox(0, "Ready", "System prepared. System will reboot after few seconds",3)  
	  halt()
	  ; Write timestamps of restart
	  While 1
	  IniWrite($resultini, $current_run, $section_wintime & "Ч" & "Shutdown at", currenttime ())
	  WEnd
	  
Elseif $firstrun==0 Then

   ToolTip("»дет анализ результатов",2000,0 , $ScriptName, 1,4)
   
   If $osversion <> "WIN_XP" Or $osversion <> "WIN_XPe" Then
   $startuptime=winstarttime()
   $wbootime=winboottime()
   IniWrite($resultini, $current_run, $section_wintime & "Ч" & "Startup at", $startuptime)
   IniWrite($resultini, $current_run, $section_wintime & "Ч" & "Boot time", $wbootime)
   EndIf
   
   PauseTime(5)
   
   $all_idle=IniRead($resultini, $current_run, $section_daemon & "Ч" & "All IDLE time at ",0)
   $time_shutdown=IniRead($resultini, $current_run, $section_wintime & "Ч" & "Shutdown at",0)
   $time_startup=IniRead($resultini, $current_run, $section_wintime & "Ч" & "Startup at",0)
  
	
   $Start=Timecount($time_startup)
   $Stop=Timecount($time_shutdown)
   $idle=Timecount($all_idle)

   $restarttime=$Start-$Stop
   $windowsstart=$idle-$Start-5

   IniWrite($resultini, $current_run, "Time to restart (in seconds)", $restarttime)
   IniWrite($resultini, $current_run, "Windows boot time (in seconds)", $windowsstart)
   
   PauseTime(5)
   
   IniWrite($mainini, $section_runs, "Left", $runs_left-1)

   If $lastrun==1 Then
   ToolTip("ѕоследний прогон. ¬ывод результатов...",2000,0 , $ScriptName, 1,4)
   
	  ; Clean temp files in startup
	  If FileExists(@StartupDir & "\boottime.lnk") Then
		 FileDelete(@StartupDir & "\boottime.lnk")
	  EndIf
		 
	  If FileExists(@StartupCommonDir & "\boottime.lnk") Then
		 FileDelete(@StartupCommonDir & "\boottime.lnk")
	  EndIf
	  
	  If FileExists(@StartupDir & "\BTDaemon.lnk") Then
		 FileDelete(@StartupDir & "\BTDaemon.lnk")
	  EndIf  
	  
	  If FileExists($mainini) Then FileDelete($mainini)
	  ;If DirGetSize($ScriptFolder) <> -1 Then DirRemove($ScriptFolder, 1)
		 
	  ; Clean registry entries
	  local $t2
		 While $t2 <= Ubound($RegistryArray)-1
		 If RegRead($RegistryArray[$t2], "BootTime")<>"" Then
		 RegDelete($RegistryArray[$t2], "BootTime")
		 EndIf
		 $t2 = $t2 + 1
		 WEnd
	  
   
		 ; Last script messages
		 $excel_need=IniRead($mainini, $section_daemon, "Excel", 0)
		 If $excel_need==0 then
			MsgBox(0,"","Script Done. Open BTResult.ini for results")
		 Else
		 resulttoxls ()
		 MsgBox(0,"","Script Done. Results stored in BTresults.xls")
		 EndIf
   
   
   Else
   
 
   MsgBox(0, "Ready", "System will reboot after few seconds",3)  
   halt()
   
   ; Write timestamps of restart
   $current_run="Current run #" & $run+1
	  While 1
	  IniWrite($resultini, $current_run, $section_wintime & "Ч" & "Shutdown at", currenttime ())
	  WEnd
   EndIf

   

EndIf



