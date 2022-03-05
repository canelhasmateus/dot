sudo apt update
sudo apt install elvish fish -y
chsh -s /usr/bin/fish
sh -c "$(curl -fsSL https://starship.rs/install.sh)"

echo "starship init fish | source" >> ~/.config/fish/config.fish
