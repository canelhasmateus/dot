#! /bin/bash
today=$(date +'%Y-%m-%d')
f="${HOME}/.canelhasmateus/journal/${today}.md"
[[ ! -f "$f" ]] && echo "$today" >"$f"

/opt/homebrew/bin/nvim -c 'normal Gek' \
    -c 'map <A-s> <Esc>:wq<CR>' -c 'imap <A-s> <Esc>:wq<CR>' \
    -c 'map <A-d> <Esc>:q!<CR>' -c 'imap <A-d> <Esc>:q!<CR>' \
    -- "$f"

echo "___" >>"$f"
