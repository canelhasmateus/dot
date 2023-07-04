#! /bin/bash
f="$(mktemp)"

/opt/homebrew/bin/nvim -c 'startinsert' \
  -c 'map <A-s> <Esc>:wq<CR>' -c 'imap <A-s> <Esc>:wq<CR>' \
  -c 'map <A-d> <Esc>:q!<CR>' -c 'imap <A-d> <Esc>:q!<CR>' \
  -- "$f"
written=$(cat "$f")

if [ -n "$written" ]; then

  content=$(
    cat <<-EOF
\`\`\`blurb $(date +"%Y-%m-%d %H:%M:%S %z")
   $written
\`\`\`

EOF

  )

  echo "$content" >>"${HOME}/.canelhasmateus/blurbs.md"

  true
fi
