#!/bin/bash

# Update and upgrade
sudo apt update && sudo apt upgrade -y 

# Install zsh
sudo apt install zsh -y
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
