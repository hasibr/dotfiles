#!/bin/zsh

# Install macOS dependencies
if [[ "$OSTYPE" == "darwin"* ]]; then
  source ./install-deps-macos.sh
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  source ./install-deps-linux.sh
fi

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch v0.8.0

source $HOME/.asdf/asdf.sh

asdf plugin add nodejs
NODEJS_CHECK_SIGNATURES=no asdf install nodejs 14.17.0
asdf global nodejs $(asdf list nodejs | tail -1 | sed 's/^ *//g')

npm install -g neovim
