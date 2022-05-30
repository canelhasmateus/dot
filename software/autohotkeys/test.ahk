#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

SoundChime( duration := 2000) {
	SoundPlay, %A_ScriptDir%\blob\nightchime.wav
}

SoundChime( )
Sleep,  10000