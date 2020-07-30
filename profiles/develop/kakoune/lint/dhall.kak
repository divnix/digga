hook -group lint global WinSetOption filetype=dhall %{
  set buffer lintcmd '/etc/xdg/kak/autoload/lint/dhall.sh $1'
  lint-enable
  set buffer formatcmd "dhall format"
  hook buffer BufWritePre .* %{
    format
    lint
  }
}
