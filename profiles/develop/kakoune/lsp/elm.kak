# elm formating is currently broken in els so use formatcmd as workaround
hook -group lsp global WinSetOption filetype=elm %{
  set buffer formatcmd "elm-format --stdin --yes --elm-version 0.19"
  lsp-enable-window
}
