#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         Sp1ker

 Script Function:
	Run of Boot time script

#ce ----------------------------------------------------------------------------

#include "lib.au3"

;WinMinimizeAll()
;Opt("WinTitleMatchMode", 2)

$run=readrun()
$current_run="Current run #" & $run

If $CMDLine[0] > 0 Then IniWrite($resultini, $current_run, $cmdline[1], currenttime ())
