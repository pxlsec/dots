import XMonad

import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP

import XMonad.Util.EZConfig
import XMonad.Util.Ungrab

import XMonad.Layout.ThreeColumns



myLayout = tiled ||| Mirror tiled ||| Full ||| threeCol 
  where
    threeCol = ThreeColMid nmaster delta ratio
    tiled = Tall nmaster delta ratio
    nmaster = 1 
    ratio =   1/2 
    delta =  3/100 

myConfig = def
  { modMask = mod4Mask
  , layoutHook = myLayout
  }

  `additionalKeysP`
  [ ("M-S-z",       spawn "xscreensaver-command -lock")
  , ("M-<Return>",  spawn "alacritty")
  , ("M-b",         spawn "firefox")
  , ("M-<Print>",   spawn "maim -u $(xdotool getactivewindow) | xclip -selection clipboard -t image/png")
  ]

main :: IO ()
main = xmonad . ewmhFullscreen . ewmh . xmobarProp $ myConfig


