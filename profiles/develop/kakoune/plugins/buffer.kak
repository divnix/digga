hook global WinDisplay .* info-buffers

map global user b ':enter-buffers-mode<ret>'              -docstring 'buffers…'
map global user B ':enter-user-mode -lock buffers<ret>'   -docstring 'buffers (lock)…'
