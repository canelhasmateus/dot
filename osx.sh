#! /bin/bash

function scriptDir() {
    cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd
}

function linkGroup() {
    ormosRoot=$(git -C "$(scriptDir)" rev-parse --show-toplevel)

    echo "Linking Group"
    column -t <(
        for pair in "$@"; do

            read -r from to <<<"$pair"
            original=$"$ormosRoot/$from"
            symbol="$HOME/$to"

            {
                mkdir -p "$(dirname "$symbol")"
                rm -rf "$symbol"
                ln -s "$original" "$symbol"
            } &>/dev/null && echo "$from <<- $to" || echo "Failed $from $to"

        done
    )
}

#
#
#

baseGroup=(
    '../limni/lists/stream/articles.tsv .canelhasmateus/articles.tsv'
    '../nisi/blurbs.md .canelhasmateus/blurbs.md'
    '../nisi/zshrc .zshrc'
    '../nisi/journal .canelhasmateus/journal'

    './shared-lib .canelhasmateus/lib'
    './shared-config .canelhasmateus/config'
    './shared-config/osx-colima.yaml .colima/default/colima.yaml'
    './shared-config/osx-alacritty.yml .config/alacritty/alacritty.yml'
)
linkGroup "${baseGroup[@]}"

# vim
plugfile=$(mktemp)
plugdests=(
    ~/.local/share/nvim/site/autoload/plug.vim
    ~/.vim/autoload/plug.vi
)
vimGroup=(
    "./settings-nvim/lua .config/nvim/lua"
    "./settings-nvim/.vimrc .vimrc"
    "./settings-nvim/.vimrc .config/nvim/init.vim"
    "./settings-nvim/.ideavimrc .ideavimrc"
)

curl -fL "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" --create-dirs -o "$plugfile"
rm -rf ~/.local/share/nvim/site/pack/packer/start/packer.nvim
rm -rf ~/.cache/nvim.local/share/nvim/site/pack/packer/start/packer.nvim
for dest in "${plugdests[@]}"; do
    mkdir -p "$(dirname "$dest") " && cp "$plugfile" "$dest"
done
linkGroup "${vimGroup[@]}"
# vscode
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

codeGroup=(
    "./settings-vscode/settings-mac.json Library/Application Support/Code/User/settings.json"
    "./settings-vscode/keybindings-mac.json Library/Application Support/Code/User/keybindings.json"
)

linkGroup "${codeGroup[@]}"
# for plugin in "${plugins[@]}"; do
#     code --install-extension "$plugin"
# done

# IntelliJ
versions=(
    "Library/Application Support/JetBrains/IntelliJIdea2021.3"
    "Library/Application Support/JetBrains/IntelliJIdea2022.2"
    "Library/Application Support/JetBrains/IntelliJIdea2023.1"
    "Library/Application Support/JetBrains/DataSpell2023.1"
)

for version in "${versions[@]}"; do
    group=(
        "./config-intellij/keymaps/macnelhas.xml $version/settingsRepository/repository/keymaps/macnelha.xml"
        "./config-intellij/keymaps/macnelhas.xml $version/keymaps/macnelha.xml"
        "./config-intellij/templates $version/templates"
        "./config-intellij/quicklists $version/quicklists"
        "./config-intellij/plugins/postfix $version/intellij-postfix-templates_templates"
    )
    linkGroup "${group[@]}"
done

# system
# dest=$(mktemp)
# curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip -o "$dest"
# todo resolve *.ttf expansion - unzip "$dest" && mv "$(dirname $dest)/*.ttf" ~/Library/Fonts

echo "Finished!"
