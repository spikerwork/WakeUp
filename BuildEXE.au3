; Auto builder files for Wake script
#include "Libs\libs.au3"

RunWait(@ProgramFilesDir & "\AutoIt3\Aut2Exe\Aut2exe.exe /in " & @ScriptDir & "\WakeClient.au3 /out " & @ScriptDir & "\" & $WakeClient & " /comp 4 /x86")
RunWait(@ProgramFilesDir & "\AutoIt3\Aut2Exe\Aut2exe.exe /in " & @ScriptDir & "\WakeDaemon.au3 /out " & @ScriptDir & "\" & $WakeDaemon & " /comp 4 /x86")
RunWait(@ProgramFilesDir & "\AutoIt3\Aut2Exe\Aut2exe.exe /in " & @ScriptDir & "\WakeServer.au3 /out " & @ScriptDir & "\" & $WakeServer & " /comp 4 /x86")
RunWait(@ProgramFilesDir & "\AutoIt3\Aut2Exe\Aut2exe.exe /in " & @ScriptDir & "\WakePrepare.au3 /out " & @ScriptDir & "\" & $WakePrepare & " /comp 4 /x86")
RunWait(@ProgramFilesDir & "\AutoIt3\Aut2Exe\Aut2exe.exe /in " & @ScriptDir & "\WakeInstall.au3 /out " & @ScriptDir & "\" & $WakeInstall & " /comp 4 /x86")

;MsgBox(0,"",@ProgramFilesDir & "AutoIt3\Aut2Exe\Aut2exe.exe /in " & @ScriptDir & "\BT.au3 /out " & @ScriptDir & "\outfile.exe")