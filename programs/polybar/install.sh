sudo apt update

sudo apt-get install cmake cmake-data libcairo2-dev libxcb1-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-image0-dev libxcb-randr0-dev libxcb-util0-dev libxcb-xkb-dev pkg-config python3-xcbgen xcb-proto libxcb-xrm-dev i3-wm libasound2-dev libmpdclient-dev libiw-dev libcurl4-openssl-dev libpulse-dev -y

sudo apt install g++ -y
sudo apt install libxcb-composite0-dev -y
sudo apt install libjsoncpp-dev -y
sudo ln -s /usr/include/jsoncpp/json/ /usr/include/json
sudo apt install python3-sphinx -y
sudo apt install libuv1-dev -y

export DISPLAY=:0
git clone https://github.com/jaagr/polybar.git
cd polybar && ./build.sh