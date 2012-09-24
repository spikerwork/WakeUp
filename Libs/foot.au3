#include-once
#cs --------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author: Sp1ker (spiker@pmpc.ru)
 Program: WakeUp Script Time Checker (WSTC)
 Site: https://github.com/spikerwork/WakeUp

 Script Function:

   The part of WakeUp Script Time Checker (WSTC)
   It contains the end of each script

#ce --------------------------------------------------------------------

$ScriptEndTime=GetUnixTimeStamp()
$ScriptEndTime=$ScriptEndTime-$ScriptStartTime
history ("Errors " & @error)
history ("Program halted. Worktime - " & $ScriptEndTime & " seconds.")
history ("------------------------------------------------------------------------")
;;; End of script