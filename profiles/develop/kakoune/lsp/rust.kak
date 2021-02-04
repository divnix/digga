hook -group lsp global WinSetOption filetype=rust %{
# racer.kak conflicts with rls completion; keep before lsp-enable
  racer-disable-autocomplete
# remove apostrophe from auto closing pairs; annoying for rust lifetimes
  set buffer auto_pairs ( ) { } [ ] '"' '"' ` `

  lsp-enable-window

  set buffer lsp_server_configuration rust.clippy_preference="on"
}
