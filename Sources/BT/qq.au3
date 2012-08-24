#cs ----------------------------------------------------------------------------

AutoIt Version: 3.3.8.1
 Author:         Sp1ker

 Script Function:
	The Part of Windows Boot time checker

#ce ----------------------------------------------------------------------------


#include "lib.au3"

WinMinimizeAll()
Opt("WinTitleMatchMode", 2)

$run=readrun()
$cpu_need=IniRead($mainini, $section_daemon, "CPU", 1)
$cpu_percent_need=IniRead($mainini, $section_daemon, "CPU_percent", 5)
$hdd_need=IniRead($mainini, $section_daemon, "HDD", 1)
$hdd_percent_need=IniRead($mainini, $section_daemon, "HDD_percent", 0)
$current_run="Current run #" & $run


   $objWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}\\.\root\cimv2")
   Local $time=0
   
   
   
   While 1
 
   $CPULoadArray[0]="0"
   $HDDLoadArray[0]="0"
  
   $time=$time+0.5
   
   ; CPU
   $WMIQuery = $objWMIService.ExecQuery("SELECT * FROM Win32_PerfRawData_PerfDisk_PhysicalDisk WHERE Name = '_Total'")
   
   For $obj In $WMIQuery
		$Current_Clock = $obj.AvgDiskQueueLength
		$Load = $obj.DiskBytesPerSec
   Next
   
   _ArrayAdd($CPULoadArray, $Load)
   
	  $CPU_Clock = "Current CPU Clock: " & $Current_Clock & " MHz"
	  $CPU_Load = "Average CPU Load: " & $Load & " %"
	
   ; HDD
   $WMIQuery2 = $objWMIService.ExecQuery ("SELECT * FROM Win32_PerfRawData_PerfDisk_PhysicalDisk WHERE Name = '_Total'")
   
   For $obj2 In $WMIQuery2
		 $hdd_activity = $obj2.PercentDiskTime
		 $hdd_bytes = $obj2.DiskBytesPerSec
   Next

   _ArrayAdd($HDDLoadArray, $hdd_activity)
   
   
	  $HDD = "Average HDD Load (PercentDiskTime): " &  $hdd_activity
	  $HDD_bytes = "HDD bytes sent (DiskBytesPerSec): " &  $hdd_bytes

   $idle = "Elapsed Time: " & $time & " sec"
   
   ToolTip("ѕрогон номер Ч " & $run & @CRLF & $CPU_Clock & @CRLF & $CPU_Load & @CRLF & $HDD & @CRLF & $HDD_bytes& @CRLF & $idle, 2000, 0, $ScriptName, 2,4)
	
   
   Sleep(500)
   
   if $time >= 55 Then
   
   Local $i=0
   Local $l=0
   Local $r
   
   ; CPU Array
   $r=Ubound($CPULoadArray)
   
   Do
   $i=$i+1
   $l=$l+$CPULoadArray[$i]
   Until $i = $r-1
   $CPULoadArray=0
   Global $CPULoadArray[1]
   
   $r=$r-1
   $AverageLoadCPU=$l/$r
   $AverageLoadCPU=StringFormat ( "%d", $AverageLoadCPU)
   
   ; HDD Array
   $r=Ubound($HDDLoadArray)
   $i=0
   $l=0
   
   Do
   $i=$i+1
   $l=$l+$HDDLoadArray[$i]
   Until $i = $r-1
   $HDDLoadArray=0
   Global $HDDLoadArray[1]
   
   $r=$r-1
   $AverageLoadHDD=$l/$r
   $AverageLoadHDD=StringFormat ( "%d", $AverageLoadHDD)
   
   ; CPU Load check
   $cpu_percent_need=Number($cpu_percent_need)
   $AverageLoadCPU=Number($AverageLoadCPU)
   
   
   If $AverageLoadCPU == "" Then $AverageLoadCPU=100
   If $AverageLoadHDD == "" Then $AverageLoadHDD=100
   
	  If $AverageLoadCPU > $cpu_percent_need Then
	 
	  $cpu_activetime=IniRead($resultini, $current_run, $section_daemon & "Ч" & "CPU Activity time ", 0)
	  $cpu_activetime=$cpu_activetime+$time
	  IniWrite($resultini, $current_run, $section_daemon & "Ч" & "CPU Activity time ", $cpu_activetime)
	  IniWrite($resultini, $current_run, $section_daemon & "Ч" & "CPU Average Activity ", $AverageLoadCPU)
	  
	  $time=0
	  Else
	  IniWrite($resultini, $current_run, $section_daemon & "Ч" & "CPU IDLE at ", currenttime())
	  
	  
		 ; HDD Load Check
		 $hdd_percent_need=Number($hdd_percent_need)
		 $AverageLoadHDD=Number($AverageLoadHDD)

		 If $AverageLoadHDD > $hdd_percent_need Then
			
		 $hdd_activetime=IniRead($resultini, $current_run, $section_daemon & "Ч" & "HDD Activity time ", 0)
		 $hdd_activetime=$hdd_activetime+$time
		 IniWrite($resultini, $current_run, $section_daemon & "Ч" & "HDD Activity time ", $hdd_activetime)
		 IniWrite($resultini, $current_run, $section_daemon & "Ч" & "HDD Average Activity ", $AverageLoadHDD)
		 IniWrite($resultini, $current_run, $section_daemon & "Ч" & "CPU Activity time ", 0)
		 $time=0
		 Else
		 IniWrite($resultini, $current_run, $section_daemon & "Ч" & "HDD IDLE at ", currenttime())
		 ExitLoop
		 EndIf
		 
	  
	  EndIf
	  
   
   EndIf
   WEnd

;IniWrite($resultini, $current_run, $section_daemon & "Ч" & "All IDLE time at ", currenttime ())
	  
;Run($parser, $ScriptFolder)
