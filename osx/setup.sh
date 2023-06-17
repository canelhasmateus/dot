installFonts() {
    curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip -o ./mono.zip
    unzip ./mono.zip -d ./mono
    mv ./mono/*.ttf ~/Library/Fonts
    rm -rf ./mono
    rm ./mono.zip
}

installCodePlugins() {

    plugins=(
        "canelhasmateus.jewel"
        "alefragnani.project-manager"
        "usernamehw.errorlens"
        "DavidAnson.vscode-markdownlint"
        "znck.grammarly"
        "formulahendry.code-runner"
        "ryuta46.multi-command"

        "canelhasmateus.partial"
        "percygrunwald.vscode-intellij-recent-files"
        "foam.foam-vscode"
        "bierner.markdown-mermaid"
        "bpruitt-goddard.mermaid-markdown-syntax-highlighting"
        "yzhang.markdown-all-in-one"
        "eamodio.gitlens"
    )

    for plugin in "${plugin[@]}"; do
        code --install-extension "$plugin"
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

createSymLink "./osx/zsh/.zshrc" "$HOME/.zshrc"
createSymLink "./osx/zsh/.git-magic.sh" "$HOME/.git-magic.sh"
createSymLink "./software/alacritty/mac.yml" "$HOME/.config/alacritty/alacritty.yml"

vimplug="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs "$vimplug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs "$vimplug"
createSymLink "./software/nvim/lua" "$HOME/.config/nvim/lua"
createSymLink "./software/nvim/.vimrc" "$HOME/.vimrc"
createSymLink "./software/nvim/.vimrc" "$HOME/.config/nvim/init.vim"
createSymLink "./software/intellij/.ideavimrc-split" "$HOME/.ideavimrc"

createSymLink "./software/vscode/settings-mac.json" "$HOME/Library/Application Support/Code/User/settings.json"
createSymLink "./software/vscode/keybindings-mac.json" "$HOME/Library/Application Support/Code/User/keybindings.json"
createSymLink "./software/dev/mac_colima.yaml" "$HOME/.colima/_templates/colima.yaml"
createSymLink "./software/dev/mac_colima.yaml" "$HOME/.colima/default/colima.yaml"

versions=(
    "$HOME/Library/Application Support/JetBrains/IntelliJIdea2021.3"
    "$HOME/Library/Application Support/JetBrains/IntelliJIdea2022.2"
    "$HOME/Library/Application Support/JetBrains/IntelliJIdea2023.1"
    "$HOME/Library/Application Support/JetBrains/DataSpell2023.1"
)

for version in "${versions[@]}"; do
    createSymLink "./software/intellij/keymaps/macnelhas.xml" "$version/settingsRepository/repository/keymaps/macnelha.xml"
    createSymLink "./software/intellij/keymaps/macnelhas.xml" "$version/keymaps/macnelha.xml"
    createSymLink "./software/intellij/templates" "$version/templates"
    createSymLink "./software/intellij/quicklists" "$version/quicklists"
    createSymLink "./software/intellij/plugins/postfix" "$version/intellij-postfix-templates_templates"
done

# todo add pwd to git root dir
