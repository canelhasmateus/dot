#! /bin/zsh
source ~/.canelhasmateus/lib/source-zsh.sh
cd nisi
filename="$(date +"%Y-%m-%d").md"
touch "$filename"
tmux new-session -A -s docs "nvim -O $filename ./docs/todo.md"
