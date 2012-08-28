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
   
   ; CPU WMI Information
   	  
	  $WMIQuery = $objWMIService.ExecQuery("SELECT * FROM Win32_Processor", "WQL",0x10+0x20)
	  
	  For $obj In $WMIQuery
		   $Current_Clock = $obj.CurrentClockSpeed
		   $Load = $obj.LoadPercentage
	  Next
	  
	  _ArrayAdd($CPULoadArray, $Load)
	  
	  $CPU_Clock = "Current CPU Clock: " & $Current_Clock & " MHz"
	  
	  If $cpu_need==1 Then
		 
		 $CPU_Load = "Average CPU Load: " & $Load & " %"
	
	  Else
	  
		 $CPU_Load = "CPULoad monitoring off"
		 
	  EndIf
	
   ; HDD WMI Information
   
	  $WMIQuery2 = $objWMIService.ExecQuery ("SELECT * FROM Win32_PerfFormattedData_PerfDisk_PhysicalDisk WHERE Name = '_Total'")
	  
	  For $obj2 In $WMIQuery2
			; Check if it XP or 2003
			If $osversion=="WIN_XP" or $osversion=="WIN_2003" Then 
			   $hdd_activity = $obj2.CurrentDiskQueueLength ;  XP/2003
			Else
			   $hdd_activity = $obj2.PercentDiskTime ;  Vista/7
			EndIf
			
			$hdd_bytes = $obj2.DiskBytesPerSec
	  Next

	  _ArrayAdd($HDDLoadArray, $hdd_activity)
   
	  $HDD_bytes = "HDD bytes sent (DiskBytesPerSec): " &  $hdd_bytes
   
	  If $hdd_need==1 Then
		 
		 $HDD = "Average HDD Load (PercentDiskTime): " &  $hdd_activity
	
	  Else
	  
		 $HDD = "HDDLoad monitoring off"
		 
	  EndIf
	  
		 

	  $idle = "Elapsed Time: " & $time & " sec"
   
	  ToolTip("ѕрогон номер Ч " & $run & @CRLF & $CPU_Clock & @CRLF & $CPU_Load & @CRLF & $HDD & @CRLF & $HDD_bytes& @CRLF & $idle, 2000, 0, $ScriptName, 2,4)
	
	  Sleep(500)
   
   if $time >= 5 Then
   
   Local $i=0
   Local $l=0
   Local $r
   
		 ; CPU Array
		 
		 If $cpu_need==1 Then
		 
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
			
			; CPU Load check
			$cpu_percent_need=Number($cpu_percent_need)
			$AverageLoadCPU=Number($AverageLoadCPU)
			
			If $AverageLoadCPU == "" Then $AverageLoadCPU=100
			
			   If $AverageLoadCPU > $cpu_percent_need Then
			  
			   $cpu_activetime=IniRead($resultini, $current_run, $section_daemon & "Ч" & "CPU Activity time ", 0)
			   $cpu_activetime=$cpu_activetime+$time
			   IniWrite($resultini, $current_run, $section_daemon & "Ч" & "CPU Activity time ", $cpu_activetime)
			   IniWrite($resultini, $current_run, $section_daemon & "Ч" & "CPU Average Activity ", $AverageLoadCPU)
			   
			   $time=0
			   Else
			   IniWrite($resultini, $current_run, $section_daemon & "Ч" & "CPU IDLE at ", currenttime())
			   EndIf
		 
		 EndIf
		 
		 ;--------------
		 ; HDD Array
		 
		 If $hdd_need==1 Then
		 
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
			
			; HDD Load Check
			$hdd_percent_need=Number($hdd_percent_need)
			$AverageLoadHDD=Number($AverageLoadHDD)
			
			If $AverageLoadHDD == "" Then $AverageLoadHDD=100
	  
			   If $AverageLoadHDD > $hdd_percent_need Then
				  
			   $hdd_activetime=IniRead($resultini, $current_run, $section_daemon & "Ч" & "HDD Activity time ", 0)
			   $hdd_activetime=$hdd_activetime+$time
			   IniWrite($resultini, $current_run, $section_daemon & "Ч" & "HDD Activity time ", $hdd_activetime)
			   IniWrite($resultini, $current_run, $section_daemon & "Ч" & "HDD Average Activity ", $AverageLoadHDD)
			   
			   $time=0
			   Else
			   IniWrite($resultini, $current_run, $section_daemon & "Ч" & "HDD IDLE at ", currenttime())
			   EndIf
		 
		 EndIf
  
		 If $time<>0 Then ExitLoop

   
   EndIf
   WEnd

;MsgBox(0,"lol", $time & " - vremia?")

IniWrite($resultini, $current_run, $section_daemon & "Ч" & "All IDLE time at ", currenttime ())
	  
Run($parser, $ScriptFolder)
