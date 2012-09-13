#cs --------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         Sp1ker

 Script Function:

   The part of WakeUp Script Time Checker (WSTC)
   This script build all nessasary EXE files to script. Works only when autoit insstalled.

#ce --------------------------------------------------------------------
#Region AutoIt3Wrapper directives section

#AutoIt3Wrapper_Compile_both=n
#AutoIt3Wrapper_Res_Comment="Wake Install"
#AutoIt3Wrapper_Res_Description="WakeUp Script Time Checker (WSTC)"
#AutoIt3Wrapper_Res_Fileversion=0.2.0.3
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=y
#AutoIt3Wrapper_Res_Field=ProductName|WakeUp Script Time Checker
#AutoIt3Wrapper_Res_Field=ProductVersion|0.1.0.0
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Res_Language=2057
#AutoIt3Wrapper_Res_LegalCopyright=Sp1ker (spiker@pmpc.ru)
#AutoIt3Wrapper_res_requestedExecutionLevel=requireAdministrator


<<<<<<< HEAD
RunWait(@ProgramFilesDir & "\AutoIt3\Aut2Exe\Aut2exe.exe /in " & @ScriptDir & "\WakeClient.au3 /out " & @ScriptDir & "\" & $WakeClient & " /comp 4 /x86 /icon " & $icon)
RunWait(@ProgramFilesDir & "\AutoIt3\Aut2Exe\Aut2exe.exe /in " & @ScriptDir & "\WakeDaemon.au3 /out " & @ScriptDir & "\" & $WakeDaemon & " /comp 4 /x86 /icon " & $icon)
RunWait(@ProgramFilesDir & "\AutoIt3\Aut2Exe\Aut2exe.exe /in " & @ScriptDir & "\WakeServer.au3 /out " & @ScriptDir & "\" & $WakeServer & " /comp 4 /x86 /icon " & $icon)
RunWait(@ProgramFilesDir & "\AutoIt3\Aut2Exe\Aut2exe.exe /in " & @ScriptDir & "\WakePrepare.au3 /out " & @ScriptDir & "\" & $WakePrepare & " /comp 4 /x86 /icon " & $icon)
RunWait(@ProgramFilesDir & "\AutoIt3\Aut2Exe\Aut2exe.exe /in " & @ScriptDir & "\WakeInstall.au3 /out " & @ScriptDir & "\" & $WakeInstall & " /comp 4 /x86 /icon " & $icon)
=======
#Endregion

#include "Libs\libs.au3"
>>>>>>> origin/DEV

FileDelete(@ScriptDir & "\" & $WakeClient)
FileDelete(@ScriptDir & "\" & $WakeDaemon)
FileDelete(@ScriptDir & "\" & $WakeServer)
FileDelete(@ScriptDir & "\" & $WakePrepare)
FileDelete(@ScriptDir & "\" & $WakeUninstall)
FileDelete(@ScriptDir & "\" & $WakeInstall)

RunWait(@ProgramFilesDir & '\AutoIt3\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.exe /in "' & @ScriptDir & '\WakeClient.au3" /out "' & @ScriptDir & '\' & $WakeClient & '" /comp 4 /x86 /icon ' & $icon & ' /NoStatus')
RunWait(@ProgramFilesDir & "\AutoIt3\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.exe /in " & @ScriptDir & "\WakeDaemon.au3 /out " & @ScriptDir & "\" & $WakeDaemon & " /comp 4 /x86 /icon " & $icon & " /NoStatus")
RunWait(@ProgramFilesDir & "\AutoIt3\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.exe /in " & @ScriptDir & "\WakeServer.au3 /out " & @ScriptDir & "\" & $WakeServer & " /comp 4 /x86 /icon " & $icon & " /NoStatus")
RunWait(@ProgramFilesDir & "\AutoIt3\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.exe /in " & @ScriptDir & "\WakePrepare.au3 /out " & @ScriptDir & "\" & $WakePrepare & " /comp 4 /x86 /icon " & $icon & " /NoStatus")
RunWait(@ProgramFilesDir & "\AutoIt3\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.exe /in " & @ScriptDir & "\WakeUninstall.au3 /out " & @ScriptDir & "\" & $WakeUninstall & " /comp 4 /x86 /icon " & $icon & " /NoStatus")
RunWait(@ProgramFilesDir & "\AutoIt3\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.exe /in " & @ScriptDir & "\WakeInstall.au3 /out " & @ScriptDir & "\" & $WakeInstall & " /comp 4 /x86 /icon " & $icon & " /NoStatus")
