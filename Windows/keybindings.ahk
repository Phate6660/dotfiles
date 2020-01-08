;; W-w -- Firefox Nightly
#w::
    Run, "C:\Program Files\Firefox Nightly\firefox.exe" -new-tab about:blank
Return

;; W-e -- Emacs
#e::
	Run, "C:\Users\valley\Downloads\emacs-26.3-x86_64\bin\runemacs.exe"
Return

;; W-S-e -- Edit autohotkey config in Emacs
#+e::
	Run, "C:\Users\valley\Downloads\emacs-26.3-x86_64\bin\emacs.exe" ~/../../Desktop/keybindings.ahk
Return

;; W-v -- Vim
#v::
	Run, "C:\tools\vim\vim82\vim.exe"
Return
		
;; A-Return -- CMD
!Enter::
    Run, "C:\Windows\system32\cmd.exe"
Return

;; A-S-Return -- Fluent Terminal
!+Enter::
	Run, "C:\Users\valley\Desktop\Fluent Terminal"
Return

;; W-f -- File Explorer
#f::
	Run, Explorer
Return

;; W-m -- Foobar2000
#m::
	Run, "C:\Program Files (x86)\foobar2000\foobar2000.exe"
Return

;; A-Escape -- Toggle mpc via ssh
!Escape::
	Run, ssh pi@192.168.1.178 -p 22 "mpc toggle"
Return

;; A-F1 -- Previous song via mpc via ssh
!f1::
	Run, ssh pi@192.168.1.178 -p 22 "mpc prev"
Return

;; A-F2 -- Next song via mpc via ssh
!f2::
	Run, ssh pi@192.168.1.178 -p 22 "mpc next"
Return

;; W-n -- ncmpcpp via ssh
#n::
	Run, ssh -t pi@192.168.1.178 -p 22 "ncmpcpp"
Return

;; A-S-r -- restart script if changed
!+r::
	Reload
Return

;; W-s -- ssh into pi
#s::
	Run, ssh pi@192.168.1.178 -p 22
Return

;; C-S-c -- search for selected text on DDG
^+c::
{
	Send, ^c
	Sleep 50
	Run, https://duckduckgo.com/?q=%clipboard%
}
Return

;; A-S-c -- kill active window
!+c::
{
	WinGetActiveTitle, OutputVar
    WinClose, %OutputVar%
}
Return

;; C-A-f -- maximize/restore active window
^!f::
{
	WinGetPos, winWidth, winHeight, , , A  ; "A" to get the active window's pos.
    if ( winWidth == -8 and winHeight == -8) {
    WinRestore, A
    } else {
    WinMaximize, A
    }
}
Return

;; W-d -- Discord
#d::
	Run, "C:\Users\valley\AppData\Local\Discord\app-0.0.305\Discord.exe"
Return
	
;; W-S-d -- DOOM
#+d::
    Run, "C:\Users\valley\Desktop\gzdoom\gzdoom.exe" -file C:\Users\valley\Desktop\gzdoom\wads\*
Return

;; W-b -- Blender
#b::
	Run, "C:\Users\valley\Desktop\blender-2.82-56ef761381ec-windows64\blender.exe"
Return

;; W-g -- GIMP (to those offended by the name: who cares?)
#g::
	Run, "C:\Program Files\GIMP 2\bin\gimp-2.10.exe"
Return
