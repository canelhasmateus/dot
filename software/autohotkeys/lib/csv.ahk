#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%
CSVtoDict(File)
{
	array := []
	arrayOfHeaders := []
	arrayOfData := []
	
	Loop, Read, %file%
	{
		If (A_Index == 1) {	;headers
			loop,parse,A_LoopReadLine, csv
			{
				arrayOfHeaders.push(A_LoopField)
			}
		}
		Else
		{
			arrayOfData := {}
			array[A_Index - 1] := {}	;due to the way AHK works, you need to separate object references. http://www.autohotkey.com/board/topic/77221-associative-array-of-objects-help/						
			loop,parse,A_LoopReadLine, csv ;use a loop,parse so we can correctly handle literal strings & commas
			{				
				arrayOfData.push(A_LoopField)
			}
			subdict := {}	;This line is needed create a new object reference to subdict in memory (We need to clear subdict every iteration or else our first dataset will repeat)			
			For index, value in arrayOfData	;for all columns in one row, create dict of {HeaderName: DataItem, HeaderName: DataItem}
			{				
				subdict[arrayOfHeaders[index]] := value ;make a dictionary of {HeaderName: DataItem}	
			}
			array[A_Index - 1] := subdict			;==array.Insert(A_Index - 1, subdict)	;subdict := {} is needed above else this line just adds the reference to the subdict, not the new values
		}
	}
	Return array
}