#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
;#KeyHistory 0 ; Ensures user privacy when debugging is not needed
#SingleInstance Force ; The script will Reload if launched while already running
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.

#Include %A_ScriptDir%\qwerty-extend.ahk
#Include %A_ScriptDir%\qwerty-altgr.ahk

; remaps / ? to Shift
*SC073::Shift
; remaps \ | to Ctrl
*SC056::Ctrl

