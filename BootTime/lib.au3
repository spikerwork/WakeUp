#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         Sp1ker

 Script Function:
	The Lib of Windows Boot time checker

#ce ----------------------------------------------------------------------------

#include <Array.au3>
#include <GuiConstants.au3>
#include <StaticConstants.au3>
#include <File.au3>
#include <WinAPI.au3>
#include "ArrayMore.au3" ; Support MultiDimension arrays
#include "ArrayToXLS.au3" ; XLS parser

; Admin check
#RequireAdmin 
If IsAdmin()==0 Then 
   MsgBox(0, "", "Для запуска программы необходимы права администратора") ; Didn`t tested yet
   Exit
EndIf


; Functions
;
;
;
; Pause
   Func PauseTime($time)
	ProgressOn("Progress", "Pause for " & $time & " seconds", "0 seconds")
	Local $i
	For $i = 1 to $time step 1
		Sleep(1000)
		Local $p=(100/$time)*$i
		ProgressSet( $p, $i & " seconds")
    Next
	ProgressSet(100 , "Done", "Complete")
	Sleep(500)
	ProgressOff()
   EndFunc

; Shutdown function
   Func halt()
	  Shutdown(2)
   EndFunc
   
; Read current run from ini
   Func readrun()
	  $runs_all=IniRead($mainini, $section_runs, "All", "")
	  $runs_left=IniRead($mainini, $section_runs, "Left", "")
	  $run=$runs_all-$runs_left
	  Return $run
   EndFunc
   
; System start at this time
   Func winstarttime()

		 If $oslang=="0409" Then
		 ShellExecuteWait('cmd.exe', '/c systeminfo | find /I "Boot Time" > ' & $startupinfo)
		 ElseIf $oslang=="0419" Then
		 ShellExecuteWait('cmd.exe', '/c systeminfo | find /I "Время" > ' & $startupinfo)
		 EndIf
	  
	  $file=FileOpen($startupinfo, 0)
	  $line = FileReadLine($file)
	  $result = StringInStr($line, ",")
	  $startuptime=StringTrimLeft($line,$result+1)
	  FileClose($file)
	  FileDelete($startupinfo)
	  Return $startuptime

   EndFunc

; Windows boot time
   Func winboottime()
	  
	  ShellExecuteWait('cmd.exe', '/c wevtutil.exe qe Microsoft-Windows-Diagnostics-Performance/Operational /rd:true /f:Text /c:1 /q:"*[System[(EventID = 100)]]" /e:Events > ' & $bootinfo)
	  
	  $file=FileOpen($bootinfo, 0)
	  Local $r=1
	  While 1
	  $line = FileReadLine($file, $r)
	  if $line<>"" Then	
		 $r=$r+1
	  Else
		 ExitLoop
	  EndIf
	  WEnd
	  
	  $line = FileReadLine($file, $r-3)
	  $result = StringInStr($line, ":")
	  $result = StringTrimLeft($line,$result+1)
	  $res_ult = StringInStr($result, ":")
	  if $res_ult<>0 Then $result = StringTrimLeft($result,$res_ult+1)
	  $winboottime = StringTrimRight($result, 2)
	  $winboottime=$winboottime/1000
	  FileClose($file)
	  FileDelete($bootinfo)
	  Return $winboottime
   
   EndFunc


; Current time
   Func currenttime ()
   $currentdate=@HOUR & ":" & @MIN & ":" & @SEC & ":" & @MSEC
   Return $currentdate
   EndFunc

; Tells time in seconds. Input - hours:minutes:seconds
   Func Timecount($time)
   $pos = StringInStr($time, ":")
   $hour=StringLeft($time,$pos-1)
   $time=StringTrimLeft($time,$pos)
   $pos = StringInStr($time, ":")
   $min=StringLeft($time,$pos-1)
	
   $time=StringTrimLeft($time,$pos)
   $sec=StringLeft($time,2)
   $minutes=$hour*60*60+$min*60+$sec
   Return $minutes
   EndFunc

; Parsing results from ini file to excel
   Func resulttoxls ()
   Dim $resultarray[1][2]

   Local $sections = IniReadSectionNames($resultini)
   Local $i=$sections[0]

    While $i >= 1

	  Local $section = IniReadSection($resultini, $sections[$i])
	  local $l=$section[0][0]
	  
		 While $l >= 1
		 _Array2DInsert($resultarray,0, $section[$l][0] &  "|" & $section[$l][1]) 
		 $l = $l - 1
		 WEnd
	  
	_Array2DInsert($resultarray,0, $sections[$i] & "| Time")
	$i = $i - 1
   WEnd

   _Array2DInsert($resultarray,0, "Parameter | Value")
   _Array2DEmptyDel($resultarray)
   ;_ArrayDisplay($resultarray, "$avArray set manually 1D")
   _ArrayToXLS($resultarray, $resultsfile)
   EndFunc



; Vars
;
; Necessary files
$run_x86="BTRun.exe"
$bt_exe="BT.exe"
$result_parser="BTResult.exe"
$result_parser64="BTResult64.exe"
$daemon_BT="BTDaemon.exe"
$helpfile="help.txt"
$resultsfile=@HomeDrive & "\BTresults.xls" ; XLS file with results, if possible to parse it


; Ini files
$mainini = @HomeDrive & "\boottime.ini" ; Temp. Will be deleted after script finished
$resultini = @HomeDrive & "\BTResult.ini"
; Folder for script
$ScriptFolder = "BootTime" ; Name
$ScriptFolder=@HomeDrive & "\" & $ScriptFolder ; Destination
; Other
$osarch = @OSArch ; OS architecture
$osversion = @OSVersion ; Version of OS
$oslang=@MUILang ; Check system Language 0419=Rus 0409=En
$ScriptName="BootTime Tester" ; Name of script
$startupinfo = @HomeDrive & "\boot.txt" ; Tempfile for winstarttime()
$bootinfo = @HomeDrive & "\boottime.txt" ; Tempfile for winboottime()
$testexe = $ScriptFolder & "\" & $run_x86 ; Startup checker
$daemon = $ScriptFolder & "\" & $daemon_BT ; Daemon exe
$parser = $ScriptFolder & "\" & $result_parser ; Result parser exe

; Ini file vars
$section_runs="Test Runs"
$section_daemon="Daemon"
$section_script="Script path on local disk"
$section_wintime="Windows Time"

; Registry Array
Global $RegistryArray[1] 
$RegistryArray[0]="HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
if $osarch == "X64" Then
_ArrayAdd($RegistryArray, "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run")
EndIf
_ArrayAdd($RegistryArray, "HKCU\Software\Microsoft\Windows\CurrentVersion\Run")

Global $CPULoadArray[1] 
Global $HDDLoadArray[1] 

