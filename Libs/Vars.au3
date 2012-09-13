#cs --------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         Sp1ker

 Script Function:
	The main library for WakeUp Script Time Checker (WSTC)
	Contains vars

#ce --------------------------------------------------------------------

   ; ===================================================================
   ; 								Vars
   ; ===================================================================

; Folder for script
$ScriptName = "StartWakeUp" ; Name
$ScriptFolder=@HomeDrive & "\" & $ScriptName ; Destination

; Ini files
$inifile = "settings.ini" ; Temp for client. Will be deleted after script finished
$inifile = $ScriptFolder & "\" & $inifile

$resultini = $ScriptFolder & "\Result.ini" ; Contains result information
$resultsfile = $ScriptFolder & "\Results.xls" ; XLS file with results, if possible to parse it

; Help File
$helpfile="help.txt" ; Help for Install GUI

; Log files
$logfile="Log_" & @ScriptName & ".txt"
$logfile = $ScriptFolder & "\" & $logfile

; Power plans
$Power_Notebook="Notebook.pow"
$Power_Desktop="Desktop.pow"

;Icon | used only for build.exe script
$icon="alert.ico"

; System info
$osarch = @OSArch ; OS architecture
$osversion = @OSVersion ; Version of OS
$oslang=@MUILang ; Check system Language 0419=Rus 0409=En

; Some global empty varibles
Global $CPULoadArray[1] ; For daemon function
Global $HDDLoadArray[1] ; For daemon function
Global $Ready=0 ; Use in client/server greetings
Global $Done=0 ; Use in client/server first run
Global $SearchKey = "HKLM\SYSTEM\ControlSet001\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}" ; For network adapters Windows 7

; Detect script more info in head.au3
Global $ScriptInstalled
Global $ScriptInstalledType

Global $TimerStart

; Names of scripts
Global  $WakeInstall="WakeInstall.exe"
Global  $WakeUninstall="WakeUninstall.exe"
Global  $WakeServer="WakeServer.exe"
Global  $WakeClient="WakeClient.exe"
Global  $WakePrepare="WakePrepare.exe"
Global  $WakeDaemon="WakeDaemon.exe"
Global  $WakeStart="WakeStart.exe"
Global  $WakeBT="WakeBT.exe"


Global $tempfile=@HomeDrive & "\powercfg.txt" ; Temp file


;;;
;;; Vars may store in ini files
;;;

   Global $TCPport = IniRead($inifile, "Network", "TCPport", 65432 ) ; TCP port for server. Client has TCPport+1
   Global $UDPport = IniRead($inifile, "Network", "UDPport", 7 ) ; UDP port for MagicPacket
   Global $ServerIP = IniRead($inifile, "Network", "IP", "10.0.0.254" ) ; Default Server IP address
   Global $Client_IP = IniRead($inifile, "Network", "Client_IP", "192.168.1.3" ) ; Default Client IP address
   Global $MAC = IniRead($inifile, "Network", "MAC", "00:24:1D:12:CC:3B" ) ; Default Server IP address
   Global $log = IniRead($inifile, "All", "Log", 1 ) ; Log on/off. Always on.
   Global $linedebug = IniRead($inifile, "All", "LineDebug", 0 )  ; Enables trayicondebug mode + traytip func. Always off.
   Global $serverconsole = IniRead($inifile, "All", "Console", 0 )  ; Server console on/off. Server always on. Client - off.
   Global $ClientPause = IniRead($inifile, "Time", "ClientPause", 2 )
   Global $ServerPause = IniRead($inifile, "Time", "ServerPause", 3 )
   Global $WakeUpPause = IniRead($inifile, "Time", "WakeUpPause", 180 )
   Global $server_broadcast=IniRead($inifile, "Network", "Broadcast", "10.0.0.255")
   Global $OldGUID=IniRead($inifile, "PowerPlan", "Old", "")
   Global $NewGUID=IniRead($inifile, "PowerPlan", "New", "")
   ; Client settings
   Global $testrepeats = IniRead($resultini, "Client", "TestRepeat", 5)
   Global $cpu_need = IniRead($resultini, "Client", "Cpu_activity",  1)
   Global $cpu_percent_need = IniRead($resultini, "Client", "CPU_load",  5)
   Global $hdd_need = IniRead($resultini, "Client", "Hdd_activity",  1)

Global $hdd_percent_need = 0

