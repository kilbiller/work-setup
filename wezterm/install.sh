#!/bin/sh

cd "$(dirname "$0")" || exit

curl -L https://github.com/wez/wezterm/releases/download/20220624-141144-bd1b7c5d/wezterm-nightly.Ubuntu20.04.deb -o wezterm.deb
sudo apt install -y ./wezterm.deb
rm wezterm.deb
mkdir -p "$HOME/.config/wezterm"
cp wezterm.lua "$HOME/.config/wezterm"
