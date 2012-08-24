#include "Libs\libs.au3"
#include "Libs\head.au3"
$console=0
SendData($ServerIP, "ToServer|Sleep|" & "1", $TCPport)

#include "Libs\foot.au3"