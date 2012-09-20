#cs ----------------------------------------------------------------------------
 AutoIt Version: 3.3.8.1
 Author:         Sp1ker

 Script Function:
	Windows Boot time checker
	Main installer. Includes all nessasary files
 ----------------------------------------------------------------------------
 #ce

#Region AutoIt3Wrapper directives section

#AutoIt3Wrapper_Compile_both=n
#AutoIt3Wrapper_Res_Comment="Boot time checker"
#AutoIt3Wrapper_Res_Description="Windows Boot time checker BootTime)"
#AutoIt3Wrapper_Res_Fileversion=0.1.1.2
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=y
#AutoIt3Wrapper_Res_Field=ProductName|Windows Boot time checker
#AutoIt3Wrapper_Res_Field=ProductVersion|0.1.3.0
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Res_Language=1049
#AutoIt3Wrapper_Res_LegalCopyright=Sp1ker (spiker@pmpc.ru)
#AutoIt3Wrapper_res_requestedExecutionLevel=requireAdministrator
#AutoIt3Wrapper_Res_requestedExecutionLevel=highestAvailable

#Endregion




;Startup`s Directories
;-@StartupCommonDir
;-@StartupDir

;Registry entries
;-"HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
;-For x64 Win - "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run"
;-"HKCU\Software\Microsoft\Windows\CurrentVersion\Run"

;Another way to add registry keys - ShellExecute("reg", "add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v name /t REG_SZ /d var")

#ce

;Include Functions and Vars

#include "lib.au3"

WinMinimizeAll()
Opt("WinTitleMatchMode", 2)

; Help file install
FileInstall("help.txt", @TempDir & "\" & $helpfile, 1)

Local $FilesArray[1]
Local $FormWidth=360
Local $FormHigh=180
Local $cpu
Local $hdd
Local $t=0

; Creating GUI
GuiCreate($ScriptName, $FormWidth, $FormHigh)
GUISetHelp(@ComSpec & ' /C start ' & @TempDir & "\" & $helpfile) ; Display Help file

$Label_1=GuiCtrlCreateLabel("Количество прогонов теста:", 10, 15, 150, 15)
;GUICtrlSetBkColor(-1, 0x00ff00)
$TestRepeat = GUICtrlCreateInput ("5",300, 15, 40, 20)
$updown = GUICtrlCreateUpdown($TestRepeat)

GuiCtrlCreateLabel("Учитывается следующая активность системы:", 10, 40, 310, 15 )
$cpu_activity=GUICtrlCreateCheckbox(" Загруженность процессора", 10, 70, 170, 20)

$IDLE_1=GuiCtrlCreateLabel("CPU Load, %", 180, 73, 110, 20, $SS_RIGHT)
$Idle_time = GUICtrlCreateInput ("5", 300, 69, 40, 20)
GUICtrlSetLimit ($Idle_time, 20 ,2 )

$hdd_activity=GUICtrlCreateCheckbox(" Дисковая подсистема", 10, 100, 170, 20)
$excel_enabled=GUICtrlCreateCheckbox(" Export to Excel", 220, 100, 170, 20)

; Check the excel
$oExcel = ObjCreate('Excel.Application')
   If @error Then
   GUICtrlSetState ($excel_enabled, $GUI_DISABLE )
   Else
   GUICtrlSetState ($excel_enabled, $GUI_CHECKED )
EndIf

GUICtrlSetState ($cpu_activity, $GUI_CHECKED )
GUICtrlSetState ($hdd_activity, $GUI_CHECKED )

GuiCtrlCreateLabel("Нажми F1 для справки", 200, 120, 150, 15, $SS_RIGHT)
;GUICtrlSetBkColor(-1, 0x00ff00)
GUICtrlSetColor(-1, 0xeb0000)

$Button_Start=GuiCtrlCreateButton("Поехали", 10, 140, 100, 30)
GUICtrlSetState ($Button_Start, $GUI_FOCUS )
$Button_Stop=GuiCtrlCreateButton("Нехочу", 250, 140, 100, 30)

GUISetState ()

While 1
   $msg = GUIGetMsg()

   Select

   Case $msg = $GUI_EVENT_CLOSE
   ; Clean temp files
   If DirGetSize($ScriptFolder) <> -1 Then DirRemove($ScriptFolder, 1)
   If FileExists($mainini) Then FileDelete($mainini)
   FileDelete(@TempDir & "\" & $helpfile)

   ExitLoop

   Case $msg = $Button_Stop
   If DirGetSize($ScriptFolder) <> -1 Then DirRemove($ScriptFolder, 1)
   FileDelete(@TempDir & "\" & $helpfile)
   If FileExists($mainini) Then FileDelete($mainini)

   ExitLoop

   Case $msg =	$TestRepeat

		; Check runs
		If 	GUICtrlRead($TestRepeat)<2 Then
			MsgBox(1, "Предупреждение", "Количество прогонов теста должно быть больше одного")
			GUICtrlDelete($TestRepeat)
			GUICtrlDelete($updown)
			$TestRepeat = GUICtrlCreateInput ("5",310, 15, 40, 20)
			$updown = GUICtrlCreateUpdown($TestRepeat)
			GUICtrlSetLimit ($updown, 20 ,2 )
		EndIf

	Case $msg = $Button_Start

	  $TestRepeat=GUICtrlRead($TestRepeat) ; Number of run

	  If BitAnd(GUICtrlRead($cpu_activity),$GUI_CHECKED) = $GUI_CHECKED THEN;
	  $cpu=1
	  $Idle_time=GUICtrlRead($Idle_time)
	  ElseIf BitAnd(GUICtrlRead($cpu_activity),$GUI_UNCHECKED) = $GUI_UNCHECKED THEN;
	  $cpu=0
	  EndIf

	  If BitAnd(GUICtrlRead($hdd_activity),$GUI_CHECKED) = $GUI_CHECKED THEN;
	  $hdd=1
      ElseIf BitAnd(GUICtrlRead($hdd_activity),$GUI_UNCHECKED) = $GUI_UNCHECKED THEN;
      $hdd=0
	  EndIf

	  If BitAnd(GUICtrlRead($excel_enabled),$GUI_CHECKED) = $GUI_CHECKED THEN;
	  $excel=1
	  ElseIf BitAnd(GUICtrlRead($excel_enabled),$GUI_UNCHECKED) = $GUI_UNCHECKED THEN;
	  $excel=0
	  ElseIf BitAnd(GUICtrlRead($excel_enabled),$GUI_DISABLE) = $GUI_DISABLE THEN;
	  $excel=0

	  EndIf



	  ; Clean old version if it present
	  If DirGetSize($ScriptFolder) = -1 Then
		 $dirgood=DirCreate($ScriptFolder)
	  Else
		 If DirRemove($ScriptFolder, 1)=1 Then $dirgood=DirCreate($ScriptFolder)
	  EndIf

	  If $dirgood==1 Then

	  ; Clean old ini
	  If FileExists($mainini) Then FileDelete($mainini)

	  ; Write new ini
	  IniWrite($mainini, $section_runs, "Left", $TestRepeat)
	  IniWrite($mainini, $section_runs, "All", $TestRepeat)
	  IniWrite($mainini, $section_runs, "First Run", 1)
	  IniWrite($mainini, $section_script, "ScriptPath", $ScriptFolder)
	  IniWrite($mainini, $section_daemon, "CPU", $cpu)
	  IniWrite($mainini, $section_daemon, "CPU_percent", $Idle_time)
	  IniWrite($mainini, $section_daemon, "HDD", $hdd)
	  IniWrite($mainini, $section_daemon, "HDD_percent", 0)


	  IniWrite($mainini, $section_daemon, "Excel", $excel)

	; Copy files
	  If FileExists($mainini) Then $FilesArray[0]=1
	  If $osarch == "X86" Then _ArrayAdd($FilesArray, FileInstall("BTResult.exe", $ScriptFolder & "\" & $result_parser))
	  If $osarch == "X64" Then _ArrayAdd($FilesArray, FileInstall("BTResult64.exe", $ScriptFolder & "\" & $result_parser))

	  _ArrayAdd($FilesArray, FileInstall("BTRun.exe", $ScriptFolder & "\" & $run_x86))
	  _ArrayAdd($FilesArray, FileInstall("BTDaemon.exe", $ScriptFolder & "\" & $daemon_BT))
	  _ArrayAdd($FilesArray, FileInstall("help.txt", $ScriptFolder & "\" & $helpfile))

	  PauseTime(5)

		; Checking copied files
		 While $t <= Ubound($FilesArray)-1

			If $FilesArray[$t]==1 Then
			   $t=$t+1
			Else
			   MsgBox(0, "Sad News", "Не все файлы переписались")

			   Exit

			EndIf
		 WEnd


		 FileCreateShortcut ($ScriptFolder & "\" & $result_parser, @StartupCommonDir & "\BT_result_parser.lnk")
		 ;RegWrite($RegistryArray[0], "BT_result_parser","REG_SZ", '"' & $parser & '"')
		 MsgBox(0, "Good news!", "Все прошло успешно. Перезагрузка через 5 секунд", 5)

		 halt()
		 ExitLoop
	Else

		MsgBox (0, "Sad news", "Не могу создать директорию")
	  Exit
	  EndIf


	EndSelect
Wend