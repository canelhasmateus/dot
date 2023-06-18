#! /bin/zsh
f="$(mktemp)"

/opt/homebrew/bin/nvim -c 'startinsert' -c "imap ß <Esc>:wq<CR>" -c "imap <A-s> <Esc>:wq<CR>" -- "$f"
content=$(
    cat <<-EOF
\`\`\`blurb $(date +"%Y-%m-%d %H:%M:%S %z")
    $(cat "$f")
\`\`\`

EOF

)
echo "$content" >>"/Users/mateus.canelhas/Desktop/pers/ormos/osx/scripts/blurb"
