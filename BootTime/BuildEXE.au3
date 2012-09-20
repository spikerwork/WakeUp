; Auto builder files for script
#Region AutoIt3Wrapper directives section

#AutoIt3Wrapper_Compile_both=n
#AutoIt3Wrapper_Res_Comment="Boot time checker"
#AutoIt3Wrapper_Res_Description="Windows Boot time checker BootTime)"
#AutoIt3Wrapper_Res_Fileversion=0.1.1.2
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=y
#AutoIt3Wrapper_Res_Field=ProductName|Windows Boot time checker
#AutoIt3Wrapper_Res_Field=ProductVersion|0.1.3.0
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Res_Language=2057
#AutoIt3Wrapper_Res_LegalCopyright=Sp1ker (spiker@pmpc.ru)
#AutoIt3Wrapper_res_requestedExecutionLevel=requireAdministrator
#AutoIt3Wrapper_Res_requestedExecutionLevel=highestAvailable

#Endregion

#include "lib.au3"



RunWait(@ProgramFilesDir & "\AutoIt3\Aut2Exe\Aut2exe.exe /in " & @ScriptDir & "\BTDaemon.au3 /out " & @ScriptDir & "\" & $daemon_BT & " /comp 4 /x86")
RunWait(@ProgramFilesDir & "\AutoIt3\Aut2Exe\Aut2exe.exe /in " & @ScriptDir & "\BTRun.au3 /out " & @ScriptDir & "\" & $run_x86 & " /comp 4 /x86")
RunWait(@ProgramFilesDir & "\AutoIt3\Aut2Exe\Aut2exe.exe /in " & @ScriptDir & "\BTResult.au3 /out " & @ScriptDir & "\" & $result_parser & " /comp 4 /x86")
RunWait(@ProgramFilesDir & "\AutoIt3\Aut2Exe\Aut2exe.exe /in " & @ScriptDir & "\BTResult.au3 /out " & @ScriptDir & "\" & $result_parser64 & " /comp 4 /x64")
RunWait(@ProgramFilesDir & "\AutoIt3\Aut2Exe\Aut2exe.exe /in " & @ScriptDir & "\BT.au3 /out " & @ScriptDir & "\" & $bt_exe & " /comp 4 /x86")

;MsgBox(0,"",@ProgramFilesDir & "AutoIt3\Aut2Exe\Aut2exe.exe /in " & @ScriptDir & "\BT.au3 /out " & @ScriptDir & "\outfile.exe")