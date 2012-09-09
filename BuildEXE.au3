
#AutoIt3Wrapper_Run_AU3Check=n

#cs --------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         Sp1ker

 Script Function:

   The part of WakeUp Script Time Checker (WSTC)
   This script build all nessasary EXE files to script. Works only when autoit insstalled.

#ce --------------------------------------------------------------------

#include "Libs\libs.au3"

RunWait(@ProgramFilesDir & "\AutoIt3\Aut2Exe\Aut2exe.exe /in " & @ScriptDir & "\WakeClient.au3 /out " & @ScriptDir & "\" & $WakeClient & " /comp 4 /x86 /icon " & $icon)
RunWait(@ProgramFilesDir & "\AutoIt3\Aut2Exe\Aut2exe.exe /in " & @ScriptDir & "\WakeDaemon.au3 /out " & @ScriptDir & "\" & $WakeDaemon & " /comp 4 /x86 /icon " & $icon)
RunWait(@ProgramFilesDir & "\AutoIt3\Aut2Exe\Aut2exe.exe /in " & @ScriptDir & "\WakeServer.au3 /out " & @ScriptDir & "\" & $WakeServer & " /comp 4 /x86 /icon " & $icon)
RunWait(@ProgramFilesDir & "\AutoIt3\Aut2Exe\Aut2exe.exe /in " & @ScriptDir & "\WakePrepare.au3 /out " & @ScriptDir & "\" & $WakePrepare & " /comp 4 /x86 /icon " & $icon)
;RunWait(@ProgramFilesDir & "\AutoIt3\Aut2Exe\Aut2exe.exe /in " & @ScriptDir & "\WakeInstall.au3 /out " & @ScriptDir & "\" & $WakeInstall & " /comp 4 /x86 /icon " & $icon)

;MsgBox(0,"",@ProgramFilesDir & "AutoIt3\Aut2Exe\Aut2exe.exe /in " & @ScriptDir & "\BT.au3 /out " & @ScriptDir & "\outfile.exe")