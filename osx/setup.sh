installCodePlugins() {

plugins=(
            "alefragnani.project-manager" "canelhasmateus.jewel"
            "canelhasmateus.partial"
            "mark-wiemer.vscode-autohotkey-plus-plus"
            "percygrunwald.vscode-intellij-recent-files"
            "ryuta46.multi-command"
            "usernamehw.errorlens"
            "wmaurer.vscode-jumpy"

            "bierner.markdown-mermaid"
            "bpruitt-goddard.mermaid-markdown-syntax-highlighting"
            "foam.foam-vscode"
            "yzhang.markdown-all-in-one"
            "brokenprogrammer.paragraphjump"
            "DavidAnson.vscode-markdownlint"
            "znck.grammarly"

            "ms-python.python"
            "ms-vscode.anycode-typescript"
            "ms-vscode.anycode"
            "rbbit.typescript-hero"
            "VisualStudioExptTeam.vscodeintellicode"
            "eamodio.gitlens"
            "formulahendry.code-runner"

        ) 
    
    for plugin in $plugins; 
    do code --install-extension "$plugin"
    done
}

installCask() {
  brew instal "$1"
}
createSymLink() {
from=$(readlink -f "$1")
dest="$2"
mkdir -p "$(dirname "$dest")"
echo "$dest"
echo "    -> ${from}"
echo "    == ${1}"
rm -f "$dest" && ln -s "$from" "$dest"
}

#todo : stow or something

createSymLink "./software/vscode/settings-mac.json" "$HOME/Library/Application Support/Code/User/settings.json"
createSymLink "./software/vscode/keybindings-mac.json" "$HOME/Library/Application Support/Code/User/keybindings.json"
createSymLink "./software/intellij/keymaps/macnelhas.xml" "$HOME/Library/Application Support/JetBrains/IntelliJIdea2022.2/settingsRepository/repository/keymaps/macnelha.xml"
createSymLink "./software/intellij/keymaps/macnelhas.xml" "$HOME/Library/Application Support/JetBrains/IntelliJIdea2022.2/keymaps/macnelha.xml"
createSymLink "./software/intellij/templates" "$HOME/Library/Application Support/JetBrains/IntelliJIdea2022.2/templates"
createSymLink "./software/intellij/quicklists" "$HOME/Library/Application Support/JetBrains/IntelliJIdea2022.2/quicklists"
createSymLink "./software/intellij/plugins/postfix" "$HOME/Library/Application Support/JetBrains/IntelliJIdea2022.2/intellij-postfix-templates_templates"
createSymLink "./software/intellij/.ideavimrc-mac" "$HOME/.ideavimrc"
createSymLink "./software/intellij/.ideavimrc-mac" "$HOME/.vimrc"
createSymLink "./software/intellij/.ideavimrc-mac" "$HOME/.config/nvim/init.vim"
createSymLink "./software/nvim/lua" "$HOME/.config/nvim/lua"
createSymLink "./software/alacritty/mac.yml" "$HOME/.config/alacritty/alacritty.yml"

installFonts() {
    curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip -o ./mono.zip
    unzip ./mono.zip -d ./mono
    mv ./mono/*.ttf ~/Library/Fonts
    rm -rf ./mono
    rm ./mono.zip
    }

# todo add pwd to git root dir