Global Array := {}

SetWorkingDir, %A_WorkingDir%
Sub(A_WorkingDir . "\hotkey_template\*.*", 0)

Sub(strDir, intLevel)
{
	Loop, %strDir%, 0 ; now scan files only
	{
       Value := A_LoopFileFullPath
        Array[A_LoopFileName] := Value

        FileRead, content, %A_LoopFileFullPath%
        Array[A_LoopFileName] := content
	}
}

`::
; send +^{left}
send +{home}
sleep, 50
send ^{c}
fullCommand = %clipboard%


firstDigitIndex := RegExMatch(fullCommand, "[\d:]+", m)
StringLen, Length, fullCommand

template := ""

if (firstDigitIndex == 0)
{
        template := Array[fullCommand]
}
else 
{
        command := SubStr(fullCommand, 1, firstDigitIndex - 1)
        args := SubStr(fullCommand, firstDigitIndex, Length - firstDigitIndex + 1)

        args_arr := StrSplit(args, ":")


        arg1 := args_arr[1]
        arg2 := args_arr[2]
        arg3 := args_arr[3]
        arg4 := args_arr[4]

        template := Array[command]

        if(command == "p"){
                if(arg2 == ""){
                        arg2 := % arg1
                        arg3 := % arg1
                        arg4 := % arg1
                        template := Array["p_all"]
                }
        }

        template := StrReplace(template, "%arg1%", arg1)
        template := StrReplace(template, "%arg2%", arg2)
        template := StrReplace(template, "%arg3%", arg3)
        template := StrReplace(template, "%arg4%", arg4)
}

clipboard = % template

sleep, 50
SendInput ^v
sleep, 50
send !+{f}
return


; p10
; pl10
; pr10
; pb10
; plr10
; plr10
; plr10:10
; ptb10
; ptb10:10


F1::
fullCommand := "p10:10:10:10"
firstDigitIndex := RegExMatch(fullCommand, "[\d:]+", m)
StringLen, Length, fullCommand
if(firstDigitIndex == 0){
   
   return
}

command := SubStr(fullCommand, 1, firstDigitIndex - 1)
args := SubStr(fullCommand, firstDigitIndex, Length - firstDigitIndex + 1)

args_arr := StrSplit(args, ":")
arg1 := args_arr[1]
arg2 := args_arr[2]
arg3 := args_arr[3]
arg4 := args_arr[4]

template := Array[command]
template := StrReplace(template, "%arg1%", arg1)
template := StrReplace(template, "%arg2%", arg2)
template := StrReplace(template, "%arg3%", arg3)
template := StrReplace(template, "%arg4%", arg4)
MsgBox, % template

return