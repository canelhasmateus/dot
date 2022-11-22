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
    do code --install-extension $plugin
    done
}


apply_brew_taps() {
  local tap_packages=$*
  for tap in $tap_packages; do
    if brew tap | grep "$tap" > /dev/null; then
      warn "Tap $tap is already applied"
    else
      brew tap "$tap"
    fi 
  done
}
install_brew_formulas() {
  local formulas=$*
  for formula in $formulas; do
    if brew list --formula | grep "$formula" > /dev/null; then
      warn "Formula $formula is already installed"
    else
      info "Installing package < $formula >"
      brew install "$formula"
    fi
  done
}
install_brew_casks() {
  local casks=$*
  for cask in $casks; do
    if brew list --casks | grep "$cask" > /dev/null; then
      warn "Cask $cask is already installed"
    else
      info "Installing cask < $cask >"
      brew install --cask "$cask"
    fi
  done
}
install_masApps() {

    masApps=(
    "937984704"   # Amphetamine
    "1444383602"  # Good Notes 5
    "768053424"   # Gappling (svg viewer)      
    )

  info "Installing App Store apps..."
  for app in $masApps; do
    mas install $app
  done
}

orig=$(readlink -f "./osx/karabiner.json")
dest=$(echo "$HOME/.config/karabiner/assets/complex_modifications/canelhas.json")
rm -f $dest && ln $orig $dest 


orig=$(readlink -f "./software/vscode/settings-mac.json")
dest=$(echo "$HOME/Library/Application Support/Code/User/settings.json")
rm -f $dest && ln -s $orig $dest


orig=$(readlink -f "./software/vscode/keybindings-mac.json")
dest=$(echo "$HOME/Library/Application Support/Code/User/keybindings.json")
rm -f $dest && ln -s $orig $dest


orig=$(readlink -f "./software/intellij/keymaps/macnelhas.xml")
dest=$(echo "$HOME/Library/Application Support/JetBrains/IntelliJIdea2022.2/settingsRepository/repository/keymaps/macnelha.xml")
mkdir -p $(dirname $dest)parent=$(dirname $dest)
mkdir -p "$parent"
rm -f $dest && ln -s $orig $dest

orig=$(readlink -f "./software/intellij/keymaps/macnelhas.xml")
dest=$(echo "$HOME/Library/Application Support/JetBrains/IntelliJIdea2022.2/keymaps/macnelha.xml")
parent=$(dirname $dest)
mkdir -p "$parent"
rm -f $dest && ln -s $orig $dest

orig=$(readlink -f "./software/intellij/templates")
  dest=$(echo "$HOME/Library/Application Support/JetBrains/IntelliJIdea2022.2/templates")
mkdir -p $(dirname $dest)parent=$(dirname $dest)
mkdir -p "$parent"
rm -f $dest && ln -s $orig $dest

orig=$(readlink -f "./software/intellij/quicklists")
dest=$(echo "$HOME/Library/Application Support/JetBrains/IntelliJIdea2022.2/quicklists")
rm -f $dest && ln -s $orig $dest
mkdir -p $(dirname $dest)

orig=$(readlink -f "./software/intellij/plugins/postfix")
dest=$(echo "$HOME/Library/Application Support/JetBrains/IntelliJIdea2022.2/intellij-postfix-templates_templates")
mkdir -p $(dirname $dest)parent=$(dirname $dest)
mkdir -p "$parent"
rm -f $dest && ln -s $orig $dest

orig=$(readlink -f "./software/intellij/.ideavimrc-mac")
dest=$(echo "$HOME/.ideavimrc")
parent=$(dirname $dest)
mkdir -p "$parent"
rm -f $dest && ln -s $orig $dest

orig=$(readlink -f "./software/intellij/.ideavimrc-mac")
dest=$(echo "$HOME/.vimrc")
mkdir -p $(dirname $dest)
rm -f $dest && ln -s $orig $dest


#todo : stow or something

installFonts() {
    curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip -o ./mono.zip
    unzip ./mono.zip -d ./mono
    mv ./mono/*.ttf ~/Library/Fonts
    rm -rf ./mono
    rm ./mono.zip
    }