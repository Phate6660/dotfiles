--------------------------------
--  \   /  .    |     |---  \ /
--   \ /  /_\   |     |---   |
--    .  /   \  |___  |---   |
--------------------------------


----------
-- Imports
----------

import XMonad
import XMonad.ManageHook
import XMonad.Config.Desktop
import XMonad.Util.EZConfig
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout
import XMonad.Layout.Grid
import XMonad.Layout.SimplestFloat
import XMonad.Hooks.ManageHelpers
import System.Exit
import XMonad.Layout.WindowNavigation
import XMonad.Layout.NoBorders
import XMonad.Actions.CycleWS
import XMonad.Util.NamedScratchpad
import Data.Tree
import XMonad.Actions.TreeSelect
import XMonad.Hooks.WorkspaceHistory
import XMonad.StackSet as W

------------
-- Variables
------------

myTerminal = "urxvt"

------------------
-- Various Configs
------------------

myManageHook = composeAll
   [ className =? "Xmessage"  --> doFloat
   , className =? "Zenity"  --> doFloat
   , className =? "gimp"  --> doFloat
   , className =? "rld2-alt" --> doFloat
   , className =? "gzdoom"  --> doFloat
   , isFullscreen --> doFloat
   , className =? "mpv" --> hasBorder False
   , className =? "mpv" --> doFullFloat
   , className =? "st-256color"  --> doFloat
   , className =? "thunar" --> doFloat
   , className =? "Navigator" --> doFloat
   , className =? "Nightly" --> doFloat
   ]

baseConfig = desktopConfig {
      modMask = mod4Mask -- Win key
    }

myLayout = smartBorders (windowNavigation (Tall 1 (3/100) (1/2) ||| Grid ||| simplestFloat ||| Full))

myScratchPads = [
    NS "terminal" spawnTerm findTerm manageTerm        
    ]

    where
    spawnTerm = "st" ++ " -n scratchpad"
    findTerm = resource =? "scratchpad"
    manageTerm = customFloating $ W.RationalRect l t w h
        where
        h = 0.9
        w = 0.9
        t = 0.95 -h
        l = 0.95 -w

--------------
-- Main Config
--------------

main = xmonad $ baseConfig {
    terminal = myTerminal
    , layoutHook = myLayout
    , manageHook = myManageHook
    }
    `additionalKeysP`
    [ ("M-g", spawn "geany") -- IDE/Text Editor
    , ("M-f", spawn "thunar") -- File Manager
    , ("M-S-f", spawn "filezilla") -- (S)FTP File Manager
    , ("M-w", spawn "firefox-nightly") -- Web Browser
    , ("M-t", spawn "urxvt") -- Terminal
    , ("M-S-g", spawn "gimp") -- Image Editor
    , ("M-S-r", spawn "rld2-alt") -- DOOM
    , ("M-b", spawn "blender") -- 3D Modeling
    , ("M-v", spawn "vpnstat") -- VPN Info
    , ("<Print>", spawn "gnome-screenshot -i") -- Screenshot
    , ("M-M1-m", spawn "mc") -- Minecraft
    , ("C-q", spawn "notify-send.sh \"Oops.\" \"You almost quit your program.\nPlease use [Ctrl-Shift-q].\"") -- Application Quit Warning
    , ("M-l", spawn "notify-lyrics") -- Send notification with lyrics to currently playing song (mpd).
    , ("C-M1-<Space>", spawn "rofi -show run") -- Rofi
    , ("M-n", spawn "music-notify") -- Send notification with info on currently playing song.
    , ("<XF86AudioPlay>", spawn "mpc toggle") -- Play/Pause music (mpd).
    , ("<XF86AudioStop>", spawn "mpc stop") -- Stop music (mpd).
    , ("<XF86AudioNext>", spawn "mpc next") -- Next song in playlist (mpd).
    , ("<XF86AudioPrev>", spawn "mpc prev") -- Previous song in playlist (mpd).
    , ("<XF86AudioMute>", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle") -- Mute/Un-Mute Volume (pulseaudio).
    , ("<XF86AudioLowerVolume>", spawn "sh -c \"pactl set-sink-mute @DEFAULT_SINK@ false ; pactl set-sink-volume @DEFAULT_SINK@ -5%\"") -- Volume -5% (pulseaudio).
    , ("<XF86AudioRaiseVolume>", spawn "sh -c \"pactl set-sink-mute @DEFAULT_SINK@ false ; pactl set-sink-volume @DEFAULT_SINK@ +5%\"") -- Volume +5% (pulseaudio).
    , ("M-S-s", spawn "zentray") -- Systray in zenity.
    , ("M-s", spawn "urxvt -e tmux attach -t scli") -- Spawn a new urxvt window and attach scli window from tmux.
    , ("M-d", spawn "time-date") -- Send notification of time and date.
    , ("M-S-d", spawn "dunst-start") -- Start dunst.
    , ("M-S-m", spawn "openmw-launcher") -- OpenMW Launcher
    , ("M-m", spawn "openmw") -- OpenMW
    , ("M-S-n", spawn "neo-notify") -- Neofetch (ufetch) notification.
    , ("M-u", spawn "unclutter --timeout 3 --fork") -- Automatically hide mouse after 3 seconds of inactivity.
    , ("M-c", spawn "rofi -modi \"clipboard:greenclip print\" -show clipboard -run-command '{cmd}'") -- View clipboard.
    , ("M-r", spawn "xmonad --recompile; xmonad --restart") -- Restart xnomad.
    , ("C-M1-<Delete>", io (exitWith ExitSuccess)) -- Exit xnomad.
    , ("M-<Up>", sendMessage $ Go U) -- Win + Up moves focus to window above current window.
    , ("M-<Down>", sendMessage $ Go D) -- Win + Down moves focus to window below current window.
    , ("M-<Left>", sendMessage $ Go L) -- Win + Left moves focus to window to left of current window.
    , ("M-<Right>", sendMessage $ Go R) -- Win + Right moves focus to window to right of current window.
    , ("M-S-<Up>", sendMessage $ Swap U) -- Win + Up swaps window with the one above current window.
    , ("M-S-<Down>", sendMessage $ Swap D) -- Win + Down swaps window with the one below current window.
    , ("M-S-<Left>", sendMessage $ Swap L) -- Win + Left swaps window with the one to left of current window.
    , ("M-S-<Right>", sendMessage $ Swap R) -- Win + Right swaps window with the one to right of current window.
    , ("M1-<F4>", kill) -- Kill focused window.
    , ("M-x", spawn "xscreensaver-command -lock") -- Lock the screen.
    , ("C-M1-<Left>", prevWS) -- Go to previous workspace.
    , ("C-M1-<Right>", nextWS) -- Go to next workspace.
    , ("M-`", namedScratchpadAction myScratchPads "terminal") -- Terminal Scratchpad.
    ]
