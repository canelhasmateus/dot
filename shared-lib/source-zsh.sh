set -o emacs
# Ctrl-X edits command line

autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x' edit-command-line

bindkey '^[^[[D' backward-word
bindkey '^[[1;3D' backward-word

bindkey '^[[1;3C' forward-word
bindkey '^[^[[C' forward-word

bindkey '^[[1~' beginning-of-line
bindkey '^[[1;3H' beginning-of-line
bindkey '3H' beginning-of-line

bindkey '^[[4~' end-of-line
bindkey '3F' end-of-line
bindkey '^[[1;3F' end-of-line

bindkey '^H' backward-kill-word
bindkey '^[[3~' delete-char
bindkey '^[[17~' kill-word

# Todos
#bindkey '^[^D' list-choices
#bindkey '^[^D' expand-history
#bindkey '^[^D' complete-word
#bindkey '^[^D' accept-and-menu-complete
#bindkey '^[^D' expand-or-complete-prefix
#bindkey '^[^D' expand-history
#bindkey '^[^D' expand-word
#bindkey '^[^D' menu-complete
#bindkey '^[^D' menu-expand-or-complete

# Shell History
alias f='fzf'
alias ls='eza'
alias cat='bat'
alias grep='rg'
eval "$(zoxide init --cmd cd zsh)"

# fzf search
fzf=$(which fzf)
fzf=$(dirname $fzf)
fzf=$(dirname $fzf)
if [ -e "$fzf/opt/fzf/shell/completion.zsh" ]; then

	source "$fzf/opt/fzf/shell/completion.zsh"
	source "$fzf/opt/fzf/shell/key-bindings.zsh"

	which rg &>/dev/null && {
		export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
		export FZF_CTRL_T_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
	}
fi

# Todos
# brew install zsh-syntax-highlighting
# echo "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
# source ./zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
