#cs ----------------------------------------------------------------------------
 AutoIt Version: 3.3.8.1
 Author:         Sp1ker

 Script Function:
	Windows Boot time checker
 ----------------------------------------------------------------------------

;Startup`s Directories
;@StartupCommonDir
;@StartupDir

;Registry entries
;"HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
;For x64 Win - "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run"
;"HKCU\Software\Microsoft\Windows\CurrentVersion\Run"

;Another way to add registry keys - ShellExecute("reg", "add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v name /t REG_SZ /d var")
#ce
;Arrays functions include
#include <Array.au3>
WinMinimizeAll()
Opt("WinTitleMatchMode", 2)

$oslang=@MUILang ; Check system Language 0419=Rus 0409=En
$osarch = @OSArch ; OS architecture

$mainini = @HomeDrive & "\boottime.ini"
$wintime = @HomeDrive & "\boot.txt"
$testexe = @ScriptFullPath

; Current time, output H:M:S:MS
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

; Pause function
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


Local $RegistryArray[1] ; Registry Array

$RegistryArray[0]="HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
if $osarch == "X64" Then
_ArrayAdd($RegistryArray, "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run")
EndIf
_ArrayAdd($RegistryArray, "HKCU\Software\Microsoft\Windows\CurrentVersion\Run")


; Checking for first boot
If FileExists($mainini) Then
    
	  ; Check for clean system
	  If IniRead($mainini, "Script", "Clean", "No")=="Yes" Then 
		 ; System seems clean. Show results.
		 $clean = 1
		 ToolTip("System cleaning...",2000,0 , "Test seems to be done", 1,4)
   
	  If FileExists(@StartupDir & "\boottime.lnk") Then
		 FileDelete(@StartupDir & "\boottime.lnk")
	  EndIf
	  
	  If FileExists(@StartupCommonDir & "\boottime.lnk") Then
	  FileDelete(@StartupCommonDir & "\boottime.lnk")
	   EndIf
	  
	  If FileExists($wintime) Then
	  FileDelete($wintime)
	  EndIf
	  local $t2
	  While $t2 <= Ubound($RegistryArray)-1
	  If RegRead($RegistryArray[$t2], "BootTime")<>"" Then
	  RegDelete($RegistryArray[$t2], "BootTime")
	  EndIf
	  $t2 = $t2 + 1
	  WEnd
   
	  ;MsgBox(0, "Warning", "System cleared.",1)  
	  ToolTip("System cleared.",2000,0 , "Test done", 1,4)
		 
    
	
	IniWrite($mainini, "Script Times", "Script closed at", currenttime ())
	
	;Count times for computer
	
	$time_shutdown=IniRead($mainini, "System Times", "Shutdown at",0)
   	$time_startup=IniRead($mainini, "System Times", "Startup at",0)
   	$time_idle=IniRead($mainini, "Script Times", "Disk Idle for 20 seconds",0)
	
	$Start=Timecount($time_startup)
	$Stop=Timecount($time_shutdown)
	$idle=Timecount($time_idle)

	$restarttime=$Start-$Stop
	$windowsstart=$idle-$Start-20

	IniWrite($mainini, "System Times", "Time to restart (in seconds)", $restarttime)
	IniWrite($mainini, "System Times", "Windows start time (in seconds)", $windowsstart)
		 
		 
		 ShellExecute($mainini, "", "", "edit")
	  Else
		 ; System not clean. Run process
		 ToolTip("Entering main state",2000,0 , "Test running", 1,4)
		
	 	 $clean = 0
	  EndIf
Else
	  ; Prepare actions for test
	  
   $answer=MsgBox(1, "First boot detected", "System is not prepared for test" & @CR & "Prepare will take about 10 seconds")
   If $answer==1 Then 
	   
	  ToolTip("First boot",2000,0 , "Test preparing", 1,4)
		
	  PauseTime(5)
	  
	  $clean = 1
	  ; Copy script file to main disk directory
	  If (@HomeDrive & "\" & @ScriptName)<>@ScriptFullPath Then
	  FileCopy(@ScriptFullPath, @HomeDrive & "\", 1)
	  IniWrite($mainini, "Script", "Copied script file to " & @HomeDrive & "\" & ", from ", " " & @ScriptFullPath)
	  EndIf
	  
	  $testexe = @HomeDrive & "\" & @ScriptName
	  
	  ; Run add to registry function
	  Local $t
	  While $t <= Ubound($RegistryArray)-1
	  RegWrite($RegistryArray[$t], "BootTime","REG_SZ", '"' & $testexe & '" ' & $RegistryArray[$t])
	  $t = $t + 1
	  WEnd
	  $t=0
	  
	  ; Add links to Startups directory
	  FileCreateShortcut($testexe, @StartupCommonDir & "\boottime.lnk", @HomeDrive & "\", " StartupCommonDir")
	  FileCreateShortcut($testexe, @StartupDir & "\boottime.lnk", @HomeDrive & "\", " StartupDir")
	  
   MsgBox(0, "Ready", "System prepared. System will reboot after few seconds",1)  
	  ;PauseTime(5)
	  IniWrite($mainini, "Script", "Clean", "No")
	  
	  Shutdown(2)
	  
	  ; Writing timestamps of shutdown
	  While 1
	  IniWrite($mainini, "System Times", "Shutdown at", currenttime ())
	  WEnd
   Else
   $clean = 1
   MsgBox(4096, "Bye", "Script cancled and closed",1)  
   EndIf
	  
EndIf

; Main process 
If $clean==0 Then
   
   If $CMDLine[0] > 0 Then
   IniWrite($mainini, "Startup position triggered in", $cmdline[1], currenttime ())
   ToolTip("Startup position" & $cmdline[1] ,2000,0 , "Test running", 1,4)
		
   $clean=0
   $count=0
   
   Local $var = IniReadSection($mainini, "Startup position triggered in")
   If @error Then
   Else
   $count=$var[0][0]
   EndIf
   
   If $count==Ubound($RegistryArray)+1 Then
   ToolTip("HDD test" ,2000,0 , "Test running", 1,4)
   ;MsgBox(0,"Count", $count,2)

   
   ; HDD Activity
   local $r
   local $e=""
   $objWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}\\.\root\cimv2")
   While 1
   $WMIQuery = $objWMIService.ExecQuery ("SELECT * FROM Win32_PerfFormattedData_PerfDisk_PhysicalDisk WHERE Name = '_Total'")
   
   For $obj In $WMIQuery
   
   ;$ProcessorQuery = $objWMIService.ExecQuery ("SELECT * FROM Win32_PerfFormattedData_PerfOS_System WHERE Name = '_Total'")
   ;@CRLF & $obj.ProcessorQueueLength
   
   ToolTip("HDD activity: CurrentDiskQueueLength - " &  $obj.CurrentDiskQueueLength & @CRLF & $e,2000,0 , "Test running", 1,4)
   
		If $obj.CurrentDiskQueueLength < 3 Then
            
		 
			$r=$r+1
			ToolTip("HDD activity: CurrentDiskQueueLength - " &  $obj.CurrentDiskQueueLength & @CRLF & $e & @CRLF & "Idle time - " & $r*200,2000,0 , "Test running", 1,4)
			
			If $r>100 Then
			
			IniWrite($mainini, "Script Times", "Disk Idle for 20 seconds",  currenttime ())
			
			ExitLoop(2)
			EndIf
        Else
			$e="Active after - " & $r*200 & "| Queue = " & $obj.CurrentDiskQueueLength & @CRLF & $e
			IniWrite($mainini, "Script Times", "Disk activity ", currenttime () & "| Idle time before - " & $r*200 & "| Current data =" & $obj.CurrentDiskQueueLength)
			$r=0
			
		EndIf
    Next
    Sleep(200)
	WEnd

   $shutdowntime=currenttime ()
	  ToolTip("Gathering Windows info",2000,0 , "Test running", 1,4)
	
	  If $oslang=="0409" Then
	  ShellExecuteWait('cmd.exe', '/c systeminfo | find /I "Boot Time" > ' & $wintime)
	  ElseIf $oslang=="0419" Then
	  ShellExecuteWait('cmd.exe', '/c systeminfo | find /I "Время" > ' & $wintime)
	  EndIf
   Sleep(5000)
   
   $file=FileOpen($wintime, 0)
   $line = FileReadLine($file)
   $result = StringInStr($line, ",")
   $startuptime=StringTrimLeft($line,$result+1)
  
   IniWrite($mainini, "System Times", "Startup at", $startuptime)
   IniWrite($mainini, "Script Times", "Scripts finished at", $shutdowntime)
   IniWrite($mainini, "Script", "Clean", "Yes")
   Run($testexe,@HomeDrive & "\")
EndIf

EndIf

   
   
EndIf

