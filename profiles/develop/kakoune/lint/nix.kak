hook -group lint global WinSetOption filetype=nix %{
  # remove '' for nix, annoying for string literals
  set buffer auto_pairs ( ) { } [ ] '"' '"' ` `

  set buffer lintcmd '
    run () {
      nix-instantiate --parse $1 2>&1 >&- > /dev/null |
      awk ''
        {printf $NF ":" " "}
        !($NF="") !($(NF-1)="") {sub(/,  $/, "")}1
      ''
    } && run \
  '
  lint-enable
  set buffer formatcmd "nixfmt"
  hook buffer BufWritePre .* %{
    format
    lint
  }
}
