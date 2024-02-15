#! /bin/bash

function setupGcloud() {

    echo "Setting up Google Cloud."

    curl https://sdk.cloud.google.com | bash

    $SHELL
    gcloud init
    gcloud auth login
    gcloud auth application-default login
    gcloud auth configure-docker
}

function scriptDir() {
    cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd
}

function linkGroup() {
    ormosRoot=$(git -C "$(scriptDir)" rev-parse --show-toplevel)

    echo "Linking Group"
    column -t <(
        for pair in "$@"; do

            read -r from to <<<"$pair"
            original="$ormosRoot/$from"
            symbol="$HOME/$to"

            {
                parentDir=$(dirname "$symbol")
                mkdir -p "$parentDir"
                rm -rf "$symbol"
            }

            sudo ln -s "$original" "$symbol"
            if [ $? -eq 0 ]; then
                echo "$original <<- $symbol"
            else
                echo "Failed $from $to"
            fi

        done
    )
}

#
#
#

defaults write -g AppleSpacesSwitchOnActivate -bool false

baseGroup=(
    '../limni/vault/articles.tsv .canelhasmateus/articles.tsv'

    '../nisi/zshrc .zshrc'
    '../nisi/zshenv .zshenv'

    '../nisi/blurbs.md .canelhasmateus/blurbs.md'
    '../nisi/journal .canelhasmateus/journal'
    '../nisi/work .canelhasmateus/work'

    './shared-lib .canelhasmateus/lib'
    './shared-bin/journal.py ../../usr/local/bin/journal'
    './shared-bin/bookmarks.py ../../usr/local/bin/bookmarks'

    './shared-config .canelhasmateus/config'
    './shared-config/osx-colima.yaml .colima/default/colima.yaml'
    './shared-config/osx-alacritty.yml .config/alacritty/alacritty.yml'
    './shared-config/osx-gradle.kts .gradle/init.d/configure-resolution-strategy.gradle'
    './settings-tmux/tmux.conf /.tmux.conf'

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
for plugin in "${plugins[@]}"; do
    code --install-extension "$plugin"
done

# IntelliJ
{
    find ~/Library/Application\ Support/JetBrains/*AppCode* -depth 0
    find ~/Library/Application\ Support/JetBrains/*Idea* -depth 0
    find ~/Library/Application\ Support/JetBrains/*DataSpell* -depth 0
    find ~/Library/Application\ Support/JetBrains/Toolbox/apps/**/Contents -not -path "*jbr*" -depth 0
} | while read -r version; do
    version=${version#"$HOME/"}
    group=(
        "./settings-intellij/keymaps/macnelhas.xml $version/settingsRepository/repository/keymaps/macnelha.xml"
        "./settings-intellij/keymaps/macnelhas.xml $version/keymaps/macnelhas.xml"
        "./settings-intellij/templates $version/templates"
        "./settings-intellij/quicklists $version/quicklists"
        "./settings-intellij/plugins/postfix $version/intellij-postfix-templates_templates"
    )

    linkGroup "${group[@]}"
done

# system
dest=$(mktemp)
parentDir=$(dirname $dest)
curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip -o "$dest"
unzip "$dest" -d "$parentDir" && mv $parentDir/*.ttf ~/Library/Fonts

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
(
    echo
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"'
) >>/Users/mateus.canelhas/.zprofile

eval "$(/opt/homebrew/bin/brew shellenv)"
brew install jq sqlite node python jetbrains-toolbox visual-studio-code git alt-tab nvim iterm2 rg
echo "Finished!"

curl -s "https://get.sdkman.io" | bash
