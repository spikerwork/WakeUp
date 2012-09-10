#cs --------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         Sp1ker

 Script Function:

   The part of WakeUp Script Time Checker (WSTC)
   This part of script sends/recieves information from server and works with results

#ce --------------------------------------------------------------------

#Region AutoIt3Wrapper directives section

#AutoIt3Wrapper_Compile_both=n
#AutoIt3Wrapper_Res_Comment="Wake Client"
#AutoIt3Wrapper_Res_Description="WakeUp Script Time Checker (WSTC)"
#AutoIt3Wrapper_Res_Fileversion=0.2.0.2
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=y
#AutoIt3Wrapper_Res_Field=ProductName|WakeUp Script Time Checker
#AutoIt3Wrapper_Res_Field=ProductVersion|0.1.0.0
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Res_Language=2057
#AutoIt3Wrapper_Res_LegalCopyright=Sp1ker (spiker@pmpc.ru)
#AutoIt3Wrapper_res_requestedExecutionLevel=requireAdministrator

#Endregion

#include "Libs\libs.au3"
#include "Libs\head.au3"

Local $lastrun=0

; Load vars from ini
Local $ActiveTest=IniRead($resultini, "Runs", "ActiveTest", 0)
Local $GUID=IniRead($inifile, "PowerPlan", "Old", "")
Local $NewGUID=IniRead($inifile, "PowerPlan", "New", "")
$firstrun=IniRead($resultini, "Runs", "First Run", 1)
$runs_all=IniRead($resultini, "Client", "TestRepeat", $testrepeats)
$runs_left=IniRead($resultini, "Runs", "Left", 0)
$run=$runs_all-$runs_left
$current_run="Current run #" & $run

If $run==$runs_all And $firstrun<>1 Then
   $lastrun=1
   $firstrun=2
EndIf

$test_halt=IniRead($resultini, "Client", "Halt",  1)
$test_sleep=IniRead($resultini, "Client", "Sleep",  1)
$test_hiber=IniRead($resultini, "Client", "Hibernate",  1)
Local $test_options=$test_halt & $test_sleep & $test_hiber ; OSH (Off, Sleep, Hibernate)
Local $test_options_new
Local $test_options_sleep=0
Local $test_options_halt=0
Local $test_options_hiber=0

$ActiveTest_halt=IniRead($resultini, "ActiveTest", "Halt", 0)
$ActiveTest_sleep=IniRead($resultini, "ActiveTest", "Sleep", 0)
$ActiveTest_hiber=IniRead($resultini, "ActiveTest", "Hiber", 0)

If $firstrun==1 Then

   ToolTip("Prepare for fun " & $ScriptName, 2000, 0 , "First run", 1,4)
   PauseTime($ClientPause)
   SendData($ServerIP, "Test", $TCPport)
   PauseTime($ClientPause-1)
   $socket = StartTCPServer($Client_IP,$TCPport+1)
   RecieveData ($socket)

   If $Ready==1 Then

	  history ("###Connection to server established###")
	  PauseTime($ClientPause)
	  SendData($ServerIP, "ToServer|StoreValues", $TCPport)
	  PauseTime($ClientPause)
	  SendData($ServerIP, "ToServer|MAC" & "|" & $MAC, $TCPport) ; $ipdetails[2][0]
	  PauseTime($ClientPause)
	  SendData($ServerIP, "ToServer|TestRuns" & "|" & $runs_all, $TCPport)
	  PauseTime($ClientPause)
	  SendData($ServerIP, "ToServer|OptionsOSH" & "|" & $test_options, $TCPport) ; Halt, Reboot, Hibernate 111 or 000
	  PauseTime($ClientPause)
	  SendData($ServerIP, "ToServer|StoreValuesFinish", $TCPport)
	  PauseTime($ClientPause)
	  $socket = StartTCPServer($Client_IP,$TCPport+1)
	  RecieveData ($socket)

		 if $Done==1 Then

			history ("###Vars stored on server###")

			IniWrite($resultini, "Runs", "First Run", 0)
			IniWrite($resultini, "Runs", "Left", $run)
			PauseTime($ClientPause)
			halt("reboot")

		 EndIf
   EndIf





Elseif $firstrun==0 Then

   ToolTip("Run # " & $run &" . Communication with server...",2000,0 , $ScriptName, 1,4)
   ; Sleep test

   If $test_sleep==1 Then

	  $test_sleep_time=IniRead($resultini, $current_run, "Sleep", 0)

	  If $test_sleep_time==0 And $ActiveTest_sleep==0 Then

		 IniWrite($resultini, "ActiveTest", "Sleep", "Sleep")

		 PauseTime(5)

		 SendData($ServerIP, "ToServer|SleepTest|" & $run, $TCPport)

		 PauseTime($ClientPause)

		 Run($ScriptFolder & "\" & $WakeDaemon & " Sleep", $ScriptFolder)

		 halt("sleep")
		 exit

	  ElseIf $ActiveTest_sleep="Sleep" Then

		 PauseTime(10)
		 $test_options_sleep=1


	  EndIf

   Else

	 $test_options_sleep=0

   EndIf



   ; Hiber test

   If $test_hiber==1 Then

	  $test_hiber_time=IniRead($resultini, $current_run, "Hiber", 0)

	  If $test_hiber_time==0 And $ActiveTest_hiber==0 Then

		 IniWrite($resultini, "ActiveTest", "Hiber", "Hiber")

		 PauseTime(5)

		 SendData($ServerIP, "ToServer|HiberTest|" & $run, $TCPport)

		 PauseTime($ClientPause)

		 Run($ScriptFolder & "\" & $WakeDaemon & " Hiber", $ScriptFolder)
		 halt("hibernate")
		 exit

	  ElseIf $ActiveTest_hiber=="Hiber" Then

		 PauseTime(10)
		 $test_options_hiber=1

	  EndIf

   Else

	  $test_options_hiber=0

   EndIf



 ; Shutdown test

   If $test_halt==1 Then

	  $test_halt_time=IniRead($resultini, $current_run, "Halt", 0)

	  If $test_halt_time==0 And $ActiveTest_halt==0 Then

		 IniWrite($resultini, "ActiveTest", "Halt", "Halt")

		 PauseTime(5)

		 SendData($ServerIP, "ToServer|HaltTest|" & $run, $TCPport)

		 PauseTime($ClientPause)

		 FileDelete(@StartupCommonDir & "\WakeClient.lnk")
		 FileCreateShortcut ($ScriptFolder & "\" & $WakeDaemon, @StartupCommonDir & "\WakeDaemon.lnk", $ScriptFolder, " Halt")

		 halt("halt")
		 exit

	  ElseIf $ActiveTest_halt=="Halt" Then

		 FileDelete(@StartupCommonDir & "\WakeDaemon.lnk")
		 FileCreateShortcut ($ScriptFolder & "\" & $WakeClient, @StartupCommonDir & "\WakeClient.lnk")

		 PauseTime(10)
		 $test_options_halt=1


	  EndIf

   Else

	  $test_options_halt=0

   EndIf



   $test_options_new=$test_options_halt & $test_options_sleep & $test_options_hiber
   history("Test options: " & $test_options & ". Test options new " & $test_options_new)

   If $test_options==$test_options_new Then

	  history("One Cycle finished")
	  IniWrite($resultini, "Runs", "Left", $runs_left-1)
	  IniWrite($resultini, "ActiveTest", "Halt", 0)
	  IniWrite($resultini, "ActiveTest", "Hiber", 0)
	  IniWrite($resultini, "ActiveTest", "Sleep", 0)


	  MsgBox(0, "All test", "One Cycle finished", 10)


	  halt("reboot")


   EndIf



ElseIf $lastrun==1 Then

   ToolTip("Last run. Cleaning and calculating results...",2000,0 , $ScriptName, 1,4)

			PauseTime($ClientPause)

			FileDelete(@StartupCommonDir & "\WakeClient.lnk")
			FileDelete(@StartupCommonDir & "\WakeDaemon.lnk")

			SendData($ServerIP, "ClientOff", $TCPport)
			PauseTime($ClientPause)

			history("Remove test powerplan - " & $NewGUID & " Enable old plan - " & $GUID)

			; Set old power plan
			ShellExecuteWait('cmd.exe', '/c powercfg /SETACTIVE ' & $GUID)
			ShellExecuteWait('cmd.exe', '/c powercfg -DELETE ' & $NewGUID)


			; Last script messages
			$excel_need=IniRead($resultini, "Client", "Excel", 0)

			If $excel_need==0 then

			   MsgBox(0,"","Script Done. Open BTResult.ini for results")

			Else

			   resulttoxls ($resultini,$resultsfile)
			   MsgBox(0,"","Script Done. Results stored in BTresults.xls")

			EndIf


EndIf


#include "Libs\foot.au3"

