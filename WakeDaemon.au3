#include "Libs\libs.au3"
#include "Libs\head.au3"

;ActivityDaemon()
$ipdetails=_IPDetail()
SendMagicPacket("00241D12CC3B", GetBroadcast ($ipdetails[1][0], $ipdetails[3][0]))

#include "Libs\foot.au3"

