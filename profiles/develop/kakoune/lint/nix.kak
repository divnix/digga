hook -group lint global WinSetOption filetype=nix %{
  # remove '' for nix, annoying for string literals
  set buffer auto_pairs ( ) { } [ ] '"' '"' ` `

  set buffer lintcmd '/etc/xdg/kak/autoload/lint/nix.sh $1'
  lint-enable
  set buffer formatcmd "nixpkgs-fmt"
  hook buffer BufWritePre .* %{
    format
    lint
  }
}
