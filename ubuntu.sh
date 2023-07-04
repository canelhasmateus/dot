sudo apt update

sudo apt install fish -y
chsh -s /usr/bin/fish
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs https://git.io/fisher



sudo apt install cargo pkg-config libssl-dev -y
cargo install --git https://github.com/reujab/silver

fish set -U PATH $HOME/.cargo/bin $PATH
fisher install silver-prompt/fish
