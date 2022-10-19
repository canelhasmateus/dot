
apply_brew_taps() {
  local tap_packages=$*
  for tap in $tap_packages; do
    if brew tap | grep "$tap" > /dev/null; then
      warn "Tap $tap is already applied"
    else
      brew tap "$tap"
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

dest=$(echo "$HOME/.config/karabiner/assets/complex_modifications/canelhas.json")
orig=$(readlink -f "./osx/karabiner.json")
rm -f $dest && ln $orig $dest 


dest=$(echo "$HOME/Library/Application Support/Code/User/settings.json")
orig=$(readlink -f "./software/vscode/settings-mac.json")
rm -f $dest && ln -s $orig $dest


dest=$(echo "$HOME/Library/Application Support/Code/User/keybindings.json")
orig=$(readlink -f "./software/vscode/keybindings-mac.json")
rm -f $dest && ln -s $orig $dest


dest=$(echo "$HOME/Library/Application Support/JetBrains/IntelliJIdea2022.2/settingsRepository/repository/keymaps/Macnelhas.xml")
orig=$(readlink -f "./software/intellij/keymaps/Macnelhas.xml")
rm -f $dest && ln -s $orig $dest


#todo : stow or something
