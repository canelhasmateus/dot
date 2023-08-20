#! /bin/bash
today=$(date +'%Y-%m-%d')
f="${HOME}/.canelhasmateus/journal/${today}.md"
[[ ! -f "$f" ]] && echo "$today" >"$f"

tomorrow=$(date -v+1d +'%Y-%m-%d')
t="${HOME}/.canelhasmateus/journal/${tomorrow}.md"
[[ ! -f "$t" ]] && echo "$tomorrow" >"$t"

p=$(dirname "$f")
p=$(realpath "$p")
/opt/homebrew/bin/nvim -c 'normal Gek' \
    -c 'nmap ß <Esc>:wqa<CR>' -c 'imap ß <Esc>:wqa<CR>' \
    -c 'map ð <Esc>:q!<CR>' -c 'imap ð <Esc>:q!<CR>' \
    -c "nnoremap nf :Telescope find_files find_command=/opt/homebrew/bin/rg,--sortr,path,--files,${p}<CR>" -- "$f"

echo "___" >>"$f"
