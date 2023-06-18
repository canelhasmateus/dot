#! /bin/bash

function installFonts() {
    curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip -o ./mono.zip
    unzip ./mono.zip -d ./mono
    mv ./mono/*.ttf ~/Library/Fonts
    rm -rf ./mono
    rm ./mono.zip
}

function installCodePlugins() {
    # export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
    plugins=(
        "canelhasmateus.jewel"
        "vscodevim.vim"
        "mads-hartmann.bash-ide-vscode"

        "alefragnani.project-manager"
        "alefragnani.Bookmarks"
        "percygrunwald.vscode-intellij-recent-files"
        "usernamehw.errorlens"

        "formulahendry.code-runner"
        "ryuta46.multi-command"
        "znck.grammarly"
        "unifiedjs.vscode-remark"
        "egomobile.vscode-powertools"
    )

    for plugin in "${plugins[@]}"; do
        code --install-extension "$plugin"
    done
}

function ormosRoot() {
    scriptFolder=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
    git -C "$scriptFolder" rev-parse --show-toplevel
}

function linkTo() {
    from="$1"
    dest="$2"
    repoRoot=$(ormosRoot)
    cd "$repoRoot" || exit
    mkdir -p "$(dirname "$dest")"
    rm -f "$dest" && ln -s "$(realpath "$from")" "$dest"

    echo "Linked!"
    echo "    -> ${from}"
    echo "    == ${dest}"
    cd - || exit
}

linkTo "./osx/zsh/.zshrc" "$HOME/.zshrc"
linkTo "./osx/zsh/.git-magic.sh" "$HOME/.git-magic.sh"
linkTo "./osx/shortcuts" "$HOME/.automation/shortcuts"
linkTo "./osx/scripts" "$HOME/.automation/scripts"

vimplug="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs "$vimplug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs "$vimplug"
linkTo "./software/alacritty/mac.yml" "$HOME/.config/alacritty/alacritty.yml"
linkTo "./software/nvim/lua" "$HOME/.config/nvim/lua"
linkTo "./software/nvim/.vimrc" "$HOME/.vimrc"
linkTo "./software/nvim/.vimrc" "$HOME/.config/nvim/init.vim"
linkTo "./software/intellij/.ideavimrc-split" "$HOME/.ideavimrc"

linkTo "./software/vscode/settings-mac.json" "$HOME/Library/Application Support/Code/User/settings.json"
linkTo "./software/vscode/keybindings-mac.json" "$HOME/Library/Application Support/Code/User/keybindings.json"
linkTo "./software/dev/mac_colima.yaml" "$HOME/.colima/_templates/colima.yaml"
linkTo "./software/dev/mac_colima.yaml" "$HOME/.colima/default/colima.yaml"

versions=(
    "$HOME/Library/Application Support/JetBrains/IntelliJIdea2021.3"
    "$HOME/Library/Application Support/JetBrains/IntelliJIdea2022.2"
    "$HOME/Library/Application Support/JetBrains/IntelliJIdea2023.1"
    "$HOME/Library/Application Support/JetBrains/DataSpell2023.1"
)

for version in "${versions[@]}"; do
    linkTo "./software/intellij/keymaps/macnelhas.xml" "$version/settingsRepository/repository/keymaps/macnelha.xml"
    linkTo "./software/intellij/keymaps/macnelhas.xml" "$version/keymaps/macnelha.xml"
    linkTo "./software/intellij/templates" "$version/templates"
    linkTo "./software/intellij/quicklists" "$version/quicklists"
    linkTo "./software/intellij/plugins/postfix" "$version/intellij-postfix-templates_templates"
done
