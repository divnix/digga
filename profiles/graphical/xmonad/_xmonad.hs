import           XMonad
import           XMonad.Config.Desktop               (desktopConfig)
import           XMonad.Hooks.EwmhDesktops           (ewmh)
import           XMonad.Hooks.ICCCMFocus             (takeTopFocus)
import           XMonad.Hooks.ManageDocks
import           XMonad.Util.EZConfig                (additionalKeys)

import           Data.Maybe                          (fromMaybe)
import           Graphics.X11.ExtraTypes.XF86        (xF86XK_AudioLowerVolume,
                                                      xF86XK_AudioMute,
                                                      xF86XK_AudioRaiseVolume)
import           Graphics.X11.Types                  (KeyMask, KeySym, Window)
import           System.Environment                  (lookupEnv)
import           XMonad.Layout.ResizableTile         (ResizableTall(..),
                                                      MirrorResize (MirrorShrink,
                                                      MirrorExpand))
import           XMonad.Layout.MultiToggle
import           XMonad.Layout.MultiToggle.Instances

import           Control.Monad                       (liftM2)
import           Data.Monoid                         (Endo)
import           XMonad.Core                         (Layout, Query,
                                                      ScreenDetail, ScreenId,
                                                      WorkspaceId, X)
import           XMonad.Hooks.SetWMName              (setWMName)
import           XMonad.Layout.NoBorders             (smartBorders)
import           XMonad.Layout.PerWorkspace          (onWorkspace)
import           XMonad.Layout.Reflect               (reflectHoriz)
import           XMonad.Util.Cursor
import qualified XMonad.StackSet                     as S (StackSet, greedyView,
                                                            shift)

main :: IO ()
main =
  xmonad . ewmh $ desktopConfig
  { terminal           = "alacritty"
  , modMask            = myModKey
  , layoutHook         = avoidStruts myLayout
  , workspaces         = myWorkspaces
  , startupHook        = myAutostart
  , manageHook         = myManageHook
                          <+> manageHook defaultConfig
                          <+> manageDocks
  , borderWidth        = 0
  , logHook            = takeTopFocus
  }
  `additionalKeys` myKeys

myLayout = smartBorders
  .  mkToggle ( NBFULL ?? EOT)
  . onWorkspace "7:im" ( half ||| Mirror half ||| tiled ||| reflectHoriz tiled )
  $ tiled ||| reflectHoriz tiled ||| half ||| Mirror half
    where
      tiled     = ResizableTall nmaster delta ratiot []
      half      = ResizableTall nmaster delta ratioh []
      nmaster   = 1
      ratiot    = 309/500
      ratioh    = 1/2
      delta     = 1/9

myWorkspaces :: [ String ]
myWorkspaces = ["1:main", "2:art", "3:net", "4:pdf", "5:game", "6:media", "7:im", "8", "9"]

-- Move Programs by X11 Class to specific workspaces on opening
myManageHook :: Query
  ( Endo
    ( S.StackSet WorkspaceId (Layout Window) Window ScreenId ScreenDetail )
  )
myManageHook = composeAll
  [ className =? "st-256color" --> viewShift "1:main"
  , className =? "qutebrowser" --> viewShift "1:main"
  , className =? "Gimp"        --> viewShift "2:art"
  , className =? "krita"       --> viewShift "2:art"
  , className =? "qBittorrent" --> viewShift "3:torrent"
  , className =? "PCSX2"       --> viewShift "5:game"
  , className =? "RPCS3"       --> viewShift "5:game"
  , className =? "mpv"         --> viewShift "6:media"
  , className =? "Zathura"     --> viewShift "4:pdf"
  , className =? "Signal"      --> doShift "7:im"
  , className =? "Steam"       --> doFloat
  , className =? "Wine"        --> doFloat
  ]
    where viewShift = doF . liftM2 (.) S.greedyView S.shift

-- Set ModKey to the Windows Key
myModKey :: KeyMask
myModKey = mod4Mask
