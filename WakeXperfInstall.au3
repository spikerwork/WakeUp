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

ShellExecuteWait($WakeXperfInstallExe)

#include "Libs\foot.au3"