
#AutoIt3Wrapper_Run_AU3Check=n

#cs --------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         Sp1ker

 Script Function:

   The part of WakeUp Script Time Checker (WSTC)
   This script build all nessasary EXE files to script. Works only when autoit insstalled.

#ce --------------------------------------------------------------------

#include "Libs\libs.au3"

FileDelete(@ScriptDir & "\" & $WakeClient)
FileDelete(@ScriptDir & "\" & $WakeDaemon)
FileDelete(@ScriptDir & "\" & $WakeServer)
FileDelete(@ScriptDir & "\" & $WakePrepare)
FileDelete(@ScriptDir & "\" & $WakeInstall)

RunWait(@ProgramFilesDir & '\AutoIt3\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.exe /in "' & @ScriptDir & '\WakeClient.au3" /out "' & @ScriptDir & '\' & $WakeClient & '" /comp 4 /x86 /icon ' & $icon & ' /NoStatus')
RunWait(@ProgramFilesDir & "\AutoIt3\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.exe /in " & @ScriptDir & "\WakeDaemon.au3 /out " & @ScriptDir & "\" & $WakeDaemon & " /comp 4 /x86 /icon " & $icon & " /NoStatus")
RunWait(@ProgramFilesDir & "\AutoIt3\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.exe /in " & @ScriptDir & "\WakeServer.au3 /out " & @ScriptDir & "\" & $WakeServer & " /comp 4 /x86 /icon " & $icon & " /NoStatus")
RunWait(@ProgramFilesDir & "\AutoIt3\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.exe /in " & @ScriptDir & "\WakePrepare.au3 /out " & @ScriptDir & "\" & $WakePrepare & " /comp 4 /x86 /icon " & $icon & " /NoStatus")
RunWait(@ProgramFilesDir & "\AutoIt3\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.exe /in " & @ScriptDir & "\WakeInstall.au3 /out " & @ScriptDir & "\" & $WakeInstall & " /comp 4 /x86 /icon " & $icon & " /NoStatus")
