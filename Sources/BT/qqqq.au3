#include <Array.au3>

Local $CPULoadArray[1]
_ArrayAdd($CPULoadArray, "1")
_ArrayAdd($CPULoadArray, "3")
_ArrayAdd($CPULoadArray, "5")
MsgBox(0, "", Ubound($CPULoadArray))








#cs
 
 $s = "LOW"
ToolTip($s, 0, 0, "Battery Information");, $icon)
$H_TOOLTIP1 = WinGetHandle($s)
DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", $H_TOOLTIP1, "wstr", "", "wstr", "")
DllCall("user32.dll", "int", "SendMessage", "hwnd", $H_TOOLTIP1, "int", 1043, "int", 2552550, "int", 0)
Sleep(5000)


 $objWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}\\.\root\cimv2")
   Local $time=0
   Local $time2=0
   
   While 1
   
   $time2=$time2+0.5
   $time=$time+0.5
   
   ; CPU
   $WMIQuery = $objWMIService.ExecQuery("SELECT * FROM Win32_Processor", "WQL",0x10+0x20)
   ;$WMIQuery = $objWMIService.ExecQuery("SELECT * FROM Win32_PerfFormattedData_PerfOS_Processor WHERE Name = '0'")
   For $obj In $WMIQuery
		$Current_Clock = $obj.CurrentClockSpeed
		$Load = $obj.LoadPercentage
   Next
   
   
   If $Load > $cpu_percent_need Then $time=0
   
   
	  $CPU_Clock = "Current CPU Clock: " & $Current_Clock & " MHz"
	  $CPU_Load = "Average CPU Load: " & $Load & " %"
	
   ; HDD
   $WMIQuery2 = $objWMIService.ExecQuery ("SELECT * FROM Win32_PerfFormattedData_PerfDisk_PhysicalDisk WHERE Name = '_Total'")
   
   For $obj2 In $WMIQuery2
		 $hdd_activity = $obj2.PercentDiskTime
		 $hdd_bytes = $obj2.DiskBytesPerSec
   Next

   If $hdd_activity > $hdd_percent_need Or $hdd_bytes > 0 Then $time=0
   
   $HDD = "Average HDD Load (PercentDiskTime): " &  $hdd_activity
   $HDD_bytes = "HDD bytes sent (DiskBytesPerSec): " &  $hdd_bytes

   $idle = "IDLE Time: " & $time
   
   ToolTip("Прогон номер — " & $run & @CRLF & $CPU_Clock & @CRLF & $CPU_Load & @CRLF & $HDD & @CRLF & $HDD_bytes& @CRLF & $idle, 2000, 0, $ScriptName, 2,4)
	
   
   Sleep(500)
   
   if $time > 30 Then ExitLoop
   WEnd
   
   #ce