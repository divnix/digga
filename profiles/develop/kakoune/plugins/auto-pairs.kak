hook global WinCreate .* %{
  auto-pairs-enable
}

map global user s -docstring 'Surround' ': auto-pairs-surround <lt> <gt><ret>'
map global user S -docstring 'Surround++' ': auto-pairs-surround <lt> <gt> _ _ * *<ret>'
