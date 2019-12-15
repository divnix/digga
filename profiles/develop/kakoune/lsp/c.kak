hook -group lsp global WinSetOption filetype=(c|cpp) %{
  lsp-enable-window
}
