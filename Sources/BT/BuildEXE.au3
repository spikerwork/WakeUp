; Auto builder files for script
#include "lib.au3"

RunWait(@ProgramFilesDir & "\AutoIt3\Aut2Exe\Aut2exe.exe /in " & @ScriptDir & "\BTDaemon.au3 /out " & @ScriptDir & "\" & $daemon_BT & " /comp 4 /x86")
RunWait(@ProgramFilesDir & "\AutoIt3\Aut2Exe\Aut2exe.exe /in " & @ScriptDir & "\BTRun.au3 /out " & @ScriptDir & "\" & $run_x86 & " /comp 4 /x86")
RunWait(@ProgramFilesDir & "\AutoIt3\Aut2Exe\Aut2exe.exe /in " & @ScriptDir & "\BTResult.au3 /out " & @ScriptDir & "\" & $result_parser & " /comp 4 /x86")
RunWait(@ProgramFilesDir & "\AutoIt3\Aut2Exe\Aut2exe.exe /in " & @ScriptDir & "\BTResult.au3 /out " & @ScriptDir & "\" & $result_parser64 & " /comp 4 /x64")
RunWait(@ProgramFilesDir & "\AutoIt3\Aut2Exe\Aut2exe.exe /in " & @ScriptDir & "\BT.au3 /out " & @ScriptDir & "\" & $bt_exe & " /comp 4 /x86")

;MsgBox(0,"",@ProgramFilesDir & "AutoIt3\Aut2Exe\Aut2exe.exe /in " & @ScriptDir & "\BT.au3 /out " & @ScriptDir & "\outfile.exe")