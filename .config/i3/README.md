
## Dependencies

```
# Build i3 (4.22 is the first version that include gaps)
git clone https://github.com/i3/i3.git
cd i3
mkdir build
git checkout 4.23
sudo apt install libxcb1-dev libxcb-keysyms1-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-xinerama0-dev libxkbcommon-x11-dev libpango1.0-dev
meson setup build
meson compile -C build
cd build
meson install

# Create a symlink to your wallpaper at ~/Pictures/wallpaper/current.jpg

# Use to set theme (eg: Mint-Y Dark)
sudo apt install lxappearance

# Enables lockscreen
sudo apt install light-locker

# Polybar (for older distros, you shoud build from source)
sudo apt install polybar

# Play/pause media
sudo apt install playerctl

# Manage ssh-agent (put this in ~/.bashrc: eval $(keychain --eval --agents ssh --quick --quiet))
sudo apt install keychain

# For image background, install feh
sudo apt install feh
```
