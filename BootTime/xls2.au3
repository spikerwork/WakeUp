#include <Array.au3>



Local $avArrayTarget[5] = ["JPM", "Holger", "Jon", "Larry", "Jeremy"]
Local $avArraySource[5] = ["Valik", "Cyberslug", "Nutster", "Tylo", "JdeB"]

_ArrayDisplay($avArrayTarget, "$avArrayTarget BEFORE _ArrayConcatenate()")
_ArrayConcatenate($avArrayTarget, $avArraySource)
_ArrayDisplay($avArrayTarget, "$avArrayTarget AFTER _ArrayConcatenate()")




#cs
Local $NamesArray[10][2]

$NamesArray[0][0] = "Jim"
$NamesArray[0][1] = "test Jim"
$NamesArray[1][0] = "Frank"
$NamesArray[1][1] = "test Frank"
$NamesArray[2][0] = "John"
$NamesArray[2][1] = "test John"
$NamesArray[3][0] = "Larry"
$NamesArray[3][1] = "test Larry"

_ArrayDisplay($NamesArray, "$NamesArray BEFORE _ArrayInsert()")

;This is the single dimensional array insert from the help file:
;_ArrayInsert($NamesArray, 2, "New")

;~ I am trying to insert it into the correct dimension / column
;_ArrayInsert($NamesArray[2][1],"New")
;~ _ArrayInsert($NamesArray,[2][1], "New")
_InsertItem($NamesArray,"New,test New",2)

_ArrayDisplay($NamesArray, "$NamesArray AFTER _ArrayInsert()")

Func _InsertItem(ByRef $aArray, $sItem, $iPos)
 Local $sTmp
 $sTmp = StringSplit($sItem,",",2)

 Local $aTmp[UBound($aArray)+1][2]
 For $i=0 To $iPos-1
  $aTmp[$i][0]=$aArray[$i][0]
  $aTmp[$i][1]=$aArray[$i][1]
 Next
 $aTmp[$iPos][0]=$sTmp[0]
 $aTmp[$iPos][1]=$sTmp[1]
 For $i=$iPos+1 To UBound($aTmp)-1
  $aTmp[$i][0]=$aArray[$i-1][0]
  $aTmp[$i][1]=$aArray[$i-1][1]
 Next
 ReDim $aArray[UBound($aTmp)][2]
 $aArray = $aTmp
 Return $aArray
EndFunc

#ce