#! /bin/zsh
f="$(mktemp)"

/opt/homebrew/bin/nvim -c 'startinsert' -c 'imap <A-s> <Esc>:wq<CR>' -c 'imap <A-d> <Esc>:q!<CR>' -- "$f"
written=$(cat "$f")
[[ -n $written ]] && {
content=$(
    cat <<-EOF
\`\`\`blurb $(date +"%Y-%m-%d %H:%M:%S %z")
   $written
\`\`\`

EOF

)

  echo "$content" >> "~/.canelhasmateus/limni/blurbs.md"

}
