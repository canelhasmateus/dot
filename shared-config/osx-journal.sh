#! /bin/bash
today=$(date +'%Y-%m-%d')
f="${HOME}/.canelhasmateus/journal/${today}.md"
p=$(dirname "$f")
p=$(realpath "$p")

[[ ! -f "$f" ]] && echo "$today" >"$f"

/opt/homebrew/bin/nvim -c 'normal Gek' \
    -c 'nmap ß <Esc>:wq<CR>' -c 'imap ß <Esc>:wq<CR>' \
    -c 'map ð <Esc>:q!<CR>' -c 'imap ð <Esc>:q!<CR>' \
    -c "nnoremap nf :Telescope find_files find_command=/opt/homebrew/bin/rg,--sortr,path,--files,${p}<CR>" -- "$f"

echo "___" >>"$f"
