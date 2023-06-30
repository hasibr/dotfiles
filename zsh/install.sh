source "$(dirname "${BASH_SOURCE[0]}")/../install/utils.sh"

# zsh is already installed as the default shell on macOS since Catalina (10.15).
# If needed, you can install zsh on your system using Homebrew: brew install zsh

# Install oh-my-zsh
local oh_my_zsh_dir="$HOME/.oh-my-zsh"
if ! directory_exists "$oh_my_zsh_dir"; then
    printf "Installing oh-my-zsh (https://github.com/ohmyzsh/ohmyzsh)\n"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    printf "oh-my-zsh is already installed at $oh_my_zsh_dir\n"
fi

# Install powerlevel10k
printf "Installing powerlevel10k (https://github.com/romkatv/powerlevel10k)\n"
brew_install "romkatv/powerlevel10k/powerlevel10k"