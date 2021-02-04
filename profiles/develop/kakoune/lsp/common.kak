eval %sh{kak-lsp --kakoune -s $kak_session}
hook -group lsp global WinSetOption filetype=(elm|rust|c|cpp|python|dhall|haskell) %{
  lsp-auto-hover-enable

  # easily enter lsp mode
  map -docstring "language-server mode" buffer user l ': enter-user-mode lsp<ret>'

  set buffer lsp_hover_anchor true
  set buffer lsp_auto_highlight_references true

  hook buffer BufWritePre .* %{
    lsp-formatting
  }
}
