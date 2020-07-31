{ autostart, screenshots, pkgs, stoggle, volnoti }:
let inherit (pkgs) alsaUtils;
in
''
  -- Function for fullscreen toggle
  fullToggle :: X ()
  fullToggle = do
    spawn "${stoggle}"
    sendMessage $ Toggle NBFULL
    sendMessage $ SetStruts [] [minBound .. maxBound]

  setVolume :: String -> X ()
  setVolume options = do
    spawn ("${alsaUtils}/bin/amixer -q set Master " ++ options)
    spawn "${volnoti}"

  myAutostart :: X ()
  myAutostart = do
    spawn "${autostart}"
    spawn "feh --bg-fill --no-fehbg ${pkgs.adapta-backgrounds}/share/backgrounds/adapta/tri-fadeno.jpg"
    setWMName "LG3D"
    sendMessage $ SetStruts [] [minBound .. maxBound]
    setDefaultCursor xC_left_ptr

  -- Set custom keybinds below following the structure:
  -- ( ( ModifierKey, KeyPress ), Action )
  myKeys :: [ ( ( KeyMask, KeySym ), X () ) ]
  myKeys =
    -- toggle fullscreen, along with power state
    [ ( ( myModKey                              , xK_f                    )
      , fullToggle
      )
    -- resize windows in master pane
    , ( ( myModKey                              , xK_Left                 )
      , sendMessage MirrorExpand
      )
    , ( ( myModKey                              , xK_Right                )
      , sendMessage MirrorShrink
      )
    , ( ( myModKey                              , xK_Up                   )
      , sendMessage MirrorExpand
      )
    , ( ( myModKey                              , xK_Down                 )
      , sendMessage MirrorShrink
      )
    -- toggle systray
    , ( ( myModKey .|. shiftMask                , xK_f                    )
      , sendMessage ToggleStruts
      )
    -- lower volume
    , ( ( 0                                     , xF86XK_AudioLowerVolume )
      , setVolume "2%- unmute"
      )
    -- raise volume
    , ( ( 0                                     , xF86XK_AudioRaiseVolume )
      , setVolume "2%+ unmute"
      )
    -- mute volume
    , ( ( 0                                     , xF86XK_AudioMute        )
      , setVolume "toggle"
      )
    -- start qutebrowser
    , ( ( myModKey                              , xK_b                    )
      , spawn "qute"
      )
    -- screen lock
    , ( ( myModKey .|. shiftMask                , xK_l                    )

      , spawn "loginctl lock-session"
      )
    -- screenshot
    , ( ( myModKey                              , xK_Print                )
      , spawn "maim -u \
        \ | png2ff | xz -9 - \
        \ > ~/${screenshots}/$(date +%m.%d.%y_%I.%M.%S_%p).ff.xz"
      )
    -- screenshot focused window
    , ( ( myModKey .|. shiftMask                , xK_Print                )

      , spawn "maim -u -i$(xdotool getactivewindow) \
        \ | png2ff \
        \ | xz -9 - \
        \ > ~/${screenshots}/$(date +%m.%d.%y_%I.%M.%S_%p).ff.xz"
      )
    -- screenshot selection to clipboard
    , ( ( myModKey .|. controlMask              , xK_Print                )

      , spawn "maim -s -u \
        \ | xclip -selection clipboard -t image/png"
      )
    -- screenshot selection file
    , ( ( myModKey .|. controlMask .|. shiftMask, xK_Print                )

      , spawn "maim -s -u \
        \ | png2ff \
        \ | xz -9 - \
        \ > ~/${screenshots}/$(date +%m.%d.%y_%I.%M.%S_%p).ff.xz"
      )
    -- screenshot selection to imgur and paste url in clipboard
    , ( ( myModKey .|. shiftMask                , xK_i                    )

      , spawn "maim -s -u /tmp/img.png; \
        \ imgurbash2 /tmp/img.png; \
        \ rm /tmp/img.png"
      )
    -- dmenu frontend for network manager
    , ( ( myModKey                              , xK_n                    )
      , spawn "networkmanager_dmenu -fn 'monospace'"
      )
    ]
''
