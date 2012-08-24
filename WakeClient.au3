#include "Libs\libs.au3"
#include "Libs\head.au3"


;;;;;;;   $ipdetails=_IPDetail()
;;;;;;;   _ArrayDisplay($ipdetails, "$avArray as a 2D array")
Local $lastrun=0

$ipdetails=_IPDetail()


; Load vars from ini
Local $ActiveTest=IniRead($resultini, "Runs", "ActiveTest", 0)

$firstrun=IniRead($resultini, "Runs", "First Run", 1)
$runs_all=IniRead($inifile, "Client", "TestRepeat", 5)+1
$runs_left=IniRead($resultini, "Runs", "Left", "")
$run=$runs_all-$runs_left
$current_run="Current run #" & $run
If $runs_left==1 Then $lastrun=1
$test_halt=IniRead($resultini, "Client", "Off",  1)
$test_sleep=IniRead($resultini, "Client", "Sleep",  1)
$test_hiber=IniRead($resultini, "Client", "Hibernate",  1)
Local $test_options=$test_halt & $test_sleep & $test_hiber ; OSH (Off, Sleep, Hibernate)
Local $test_options_new
Local $test_options_sleep
Local $test_options_halt
Local $test_options_hiber


If $firstrun==1 Then 
   ToolTip("Идет подготовка к запуску теста " & $ScriptName,2000,0 , "Первый запуск", 1,4)
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
	  SendData($ServerIP, "ToServer|MAC" & "|" & $ipdetails[2][0], $TCPport)
	  PauseTime($ClientPause)
	  SendData($ServerIP, "ToServer|TestRuns" & "|" & $runs_all-1, $TCPport)
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
		 IniWrite($resultini, "Runs", "Left", $run-1)
		 PauseTime($ClientPause)
		 halt("reboot")
		 
		 EndIf
   EndIf
   
Else
   
    If $lastrun==1 Then ; Not approved
	  
   ToolTip("Последний прогон. Вывод результатов...",2000,0 , $ScriptName, 1,4)
   
   
   ; Last script messages
   $excel_need=IniRead($inifile, "Client", "Excel", 0)
   
   If $excel_need==0 then
	  
	  MsgBox(0,"","Script Done. Open BTResult.ini for results")
   
   Else
   
	  resulttoxls ()
	  MsgBox(0,"","Script Done. Results stored in BTresults.xls")
   
   EndIf
   
   
   EndIf
   
   
   
   
   ; Sleep test
   
   If $test_sleep==1 Then
	     
	  $test_sleep_time=IniRead($resultini, $current_run, "Sleep", 0) 
	  
	  If $test_sleep_time==0 And $ActiveTest==0 Then
	  
	  IniWrite($resultini, "Runs", "ActiveTest", "Sleep")
	  
		 
		 PauseTime(5)
		 
		 SendData($ServerIP, "ToServer|SleepTest|" & $run, $TCPport)
		 
		 PauseTime($ClientPause)
		 
		 Run($ScriptFolder & "\" & $WakeDaemon & " Sleep", $ScriptFolder)
		 halt("sleep")
		 
	  ElseIf $ActiveTest=="Sleep" Then
	  
	  MsgBox(0, "Sleep test", "Finished",10)
	  $test_options_sleep=1
	  IniWrite($resultini, "Runs", "ActiveTest", 1)
	 
	  
	  EndIf
	  
   EndIf

   $ActiveTest=IniRead($resultini, "Runs", "ActiveTest", 0)

   ; Hiber test
   
   If $test_hiber==1 Then
	     
	  $test_hiber_time=IniRead($resultini, $current_run, "Hiber", 0) 
	  
	  If $test_hiber_time==0 And $ActiveTest==1 Then
		 
		 IniWrite($resultini, "Runs", "ActiveTest", "Hiber")
		 
		 PauseTime(5)
		 
		 SendData($ServerIP, "ToServer|HiberTest|" & $run, $TCPport)
		 
		 PauseTime($ClientPause)
		 
		 Run($ScriptFolder & "\" & $WakeDaemon & " Hiber", $ScriptFolder)
		 halt("hibernate")
		 
	  ElseIf $ActiveTest=="Hiber" Then
	   
	  MsgBox(0, "Hiber test", "Finished",10)
	  IniWrite($resultini, "Runs", "ActiveTest", 2)
	  $test_options_hiber=1
	  
	  EndIf
	  
   EndIf

   $ActiveTest=IniRead($resultini, "Runs", "ActiveTest", 0)


 ; Shutdown test
   
   If $test_halt==1 Then
	     
	  $test_halt_time=IniRead($resultini, $current_run, "Halt", 0) 
	  
	  If $test_halt_time==0 And $ActiveTest==2 Then
		 
		 IniWrite($resultini, "Runs", "ActiveTest", "Halt")
		 
		 PauseTime(5)
		 
		 SendData($ServerIP, "ToServer|HaltTest|" & $run, $TCPport)
		 
		 PauseTime($ClientPause)
		 
		 FileDelete(@StartupCommonDir & "\WakeClient.lnk")
		 FileCreateShortcut ($ScriptFolder & "\" & $WakeDaemon & " Halt", @StartupCommonDir & "\WakeDaemon.lnk")
		 ;Run($ScriptFolder & "\" & $WakeDaemon & " Halt", $ScriptFolder)
		 halt("halt")
		 
	  ElseIf $ActiveTest=="Halt" Then
	  FileDelete(@StartupCommonDir & "\WakeDaemon.lnk")
	  FileCreateShortcut ($ScriptFolder & "\" & $WakeClient, @StartupCommonDir & "\WakeClient.lnk")
	  MsgBox(0, "Halt test", "Finished",10)
	  IniWrite($resultini, "Runs", "ActiveTest", 0)
	  $test_options_halt=1
	  
	  EndIf
	  
   EndIf


   $test_options_new=$test_options_halt & $test_options_sleep & $test_options_hiber
   If $test_options==$test_options_new Then
	  
	  history("One Cycle finished")
	  IniWrite($resultini, "Runs", "Left", $runs_left-1)	  
	  MsgBox(0, "All test", "All Done")
	  
   EndIf
   
  

EndIf


#include "Libs\foot.au3"

