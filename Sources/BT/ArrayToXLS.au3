; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayToXLS
; Description ...: Places the elements of an 1D or 2D array into an Excel file (XLS).
; Syntax.........: _ArrayToXLS(Const ByRef $avArray, $sFileName[, $Transpose = False[, $iStartRow = 0[, $iEndRow = 0[, $iStartCol = 0[, $iEndCol = 0]]]]])
; Parameters ....: $avArray - Array to save
;               $sFileName  - Full path to XLS file
;               $Transpose  - [optional] At 2D array changes rows and columns
;               $iStartRow  - [optional] Zero based index (row) of array to start saving at
;               $iEndRow    - [optional] Zero based index (row) of array to stop saving at, if zero then last row is taken
;               $iStartCol  - [optional] Zero based index (column) of array to start saving at
;               $iEndCol    - [optional] Zero based index (column) of array to stop saving at, if zero then last column is taken
; Return values .: Success - 1
;               Failure - 0, sets @error:
;               |1 - $avArray is not an array
;               |2 - $avArray is not 1D/2D array
;               |3 - $iStartRow is greater than $iEndRow
;               |4 - $iStartCol is greater than $iEndCol
;               |5 - couldn't create XLS file
; Author ........: Zedna
; Modified.......:
; Remarks .......: Function supports 1D and 2D arrays. All array's data are converted to String datatype.
;               This function doesn't depend on installed Microsoft Excel.
; Related .......: _ArrayToString, _ArrayToClip
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _ArrayToXLS(Const ByRef $avArray, $FileName, $Transpose = False, $iStartRow = 0, $iEndRow = 0, $iStartCol = 0, $iEndCol = 0)
    Local $nBytes

    If Not IsArray($avArray) Then SetError(1, 0, 0)
    $iDimension = UBound($avArray, 0)
    If $iDimension > 2 Then SetError(2, 0, 0)

    $iUBound1 = UBound($avArray, 1) - 1
    If $iEndRow < 1 Or $iEndRow > $iUBound1 Then $iEndRow = $iUBound1
    If $iStartRow < 0 Then $iStartRow = 0
    If $iStartRow > $iEndRow Then Return SetError(3, 0, 0)

    If $iDimension = 2 Then
        $iUBound2 = UBound($avArray, 2) - 1
        If $iEndCol < 1 Or $iEndCol > $iUBound2 Then $iEndCol = $iUBound2
        If $iStartCol < 0 Then $iStartCol = 0
        If $iStartCol > $iEndCol Then Return SetError(4, 0, 0)
    EndIf

    $hFile = _WinAPI_CreateFile($FileName, 1)
    If @error Then Return SetError(5, 0, 0)

    $str_bof = DllStructCreate('short;short;short;short;short;short')
    DllStructSetData($str_bof, 1, 0x809)
    DllStructSetData($str_bof, 2, 0x8)
    DllStructSetData($str_bof, 3, 0x0)
    DllStructSetData($str_bof, 4, 0x10)
    DllStructSetData($str_bof, 5, 0x0)
    DllStructSetData($str_bof, 6, 0x0)
    _WinAPI_WriteFile($hFile, DLLStructGetPtr($str_bof), DllStructGetSize($str_bof), $nBytes)

    Switch $iDimension
        Case 1 ; 1D array
            For $i = $iStartRow To $iEndRow ; 0 To $iUBound1
                If $Transpose Then
                    __XLSWriteCell($hFile, 0, $i - $iStartRow, $avArray[$i])
                Else
                    __XLSWriteCell($hFile, $i - $iStartRow, 0, $avArray[$i])
                EndIf
            Next
            
        Case 2 ; 2D array
            For $i = $iStartRow To $iEndRow ; 0 To $iUBound1
                For $j = $iStartCol To $iEndCol ; 0 To $iUBound2
                    If $Transpose Then
                        __XLSWriteCell($hFile, $j - $iStartCol, $i - $iStartRow, $avArray[$i][$j])
                    Else
                        __XLSWriteCell($hFile, $i - $iStartRow, $j - $iStartCol, $avArray[$i][$j])
                    EndIf
                Next
            Next
    EndSwitch

    $str_eof = DllStructCreate('short;short')
    DllStructSetData($str_eof, 1, 0x0A)
    DllStructSetData($str_eof, 2, 0x0)
    _WinAPI_WriteFile($hFile, DLLStructGetPtr($str_eof), DllStructGetSize($str_eof), $nBytes)

    _WinAPI_CloseHandle($hFile)
    Return 1
EndFunc ; ==> _ArrayToXLS

; internal helper function for _ArrayToXLS()
Func __XLSWriteCell($hFile, $Row, $Col, $Value)
    Local $nBytes

    $Value = String($Value)
    $Len = StringLen($Value)

    $str_cell = DllStructCreate('short;short;short;short;short;short')
    DllStructSetData($str_cell, 1, 0x204)
    DllStructSetData($str_cell, 2, 8 + $Len)
    DllStructSetData($str_cell, 3, $Row)
    DllStructSetData($str_cell, 4, $Col)
    DllStructSetData($str_cell, 5, 0x0)
    DllStructSetData($str_cell, 6, $Len)
    _WinAPI_WriteFile($hFile, DLLStructGetPtr($str_cell), DllStructGetSize($str_cell), $nBytes)

    $tBuffer = DLLStructCreate("byte[" & $Len & "]")
    DLLStructSetData($tBuffer, 1, $Value)
    _WinAPI_WriteFile($hFile, DLLStructGetPtr($tBuffer), $Len, $nBytes)
 EndFunc  ; ==> __XLSWriteCell
 
 ;Examples
 
 ;Dim $myArray[6] = ['A','B','C','D','E','F']

#cs
_ArrayToXLS($myArray, @ScriptDir & '\test1t.xls', True) ; transpose
_ArrayToXLS($myArray, @ScriptDir & '\test1x.xls', False, 2, 4) ; C,D,E
_ArrayToXLS($myArray, @ScriptDir & '\test1xt.xls', True, 2, 4) ; C,D,E transposed

Dim $myArray[2][3] = [['A','B','C'], ['D','E','F']]
_ArrayToXLS($myArray, @ScriptDir & '\test2.xls')
_ArrayToXLS($myArray, @ScriptDir & '\test2t.xls', True) ; transpose
_ArrayToXLS($myArray, @ScriptDir & '\test2x.xls', False, 1, 1) ; second row: D,E,F
_ArrayToXLS($myArray, @ScriptDir & '\test2xt.xls', True, 1, 1) ; second row: D,E,F transposed
_ArrayToXLS($myArray, @ScriptDir & '\test2y.xls', False, 0, 0, 1, 2) ; B,C + E,F
_ArrayToXLS($myArray, @ScriptDir & '\test2yt.xls', True, 0, 0, 1, 2) ; B,C + E,F transposed

$myArray = _FileListToArray(@ScriptDir, '*', 1)
_ArrayToXLS($myArray, @ScriptDir & '\test3.xls')
_ArrayToXLS($myArray, @ScriptDir & '\test3x.xls', False, 1) ; skip first row (contains number of files)
ShellExecute(@ScriptDir & "\test3x.xls")
#ce
