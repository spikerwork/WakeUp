#include-once
#cs --------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         Sp1ker

 Script Function:

   The part of WakeUp Script Time Checker (WSTC)
   It contains the end of each script

#ce --------------------------------------------------------------------

$ScriptEndTime=GetUnixTimeStamp()
$ScriptEndTime=$ScriptEndTime-$ScriptStartTime
history ("Errors " & @error)
history ("Program halted. Worktime - " & $ScriptEndTime & " seconds. UnixTimeStamp - " & $ScriptEndTime)
history ("------------------------------------------------------------------------")
;;; End of script