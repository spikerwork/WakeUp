#cs --------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         Sp1ker

 Script Function:
	
   The part of WakeUp Script Time Checker (WSTC)
   Xperf install. 

#ce --------------------------------------------------------------------

#include "Libs\libs.au3"
#include "Libs\head.au3"
#include "Libs\XPerf.au3"

EnvSet("SEE_MASK_NOZONECHECKS", "1") ; Skip zone checks
$WakeXperfInstallExe="wpt_x64.msi"
Run ("msiexec /i " & $WakeXperfInstallExe & " /quiet")
MsgBox(0,"", "msiexec /i " & $WakeXperfInstallExe & " /quiet")
;ShellExecuteWait($WakeXperfInstallExe)

#include "Libs\foot.au3"