source "$(dirname "${BASH_SOURCE[0]}")/../install/utils.sh"

# Install zsh
# zsh is already installed as the default shell on macOS since Catalina (10.15).
# If needed, you can install zsh on your system using Homebrew: brew install zsh
if [[ -n $(grep /zsh$ /etc/shells | tail -1) && "$SHELL" == */zsh ]]; then
    printf "Zsh is already installed and currently the shell."
else
    # Install zsh and change the shell to zsh
    brew_install "zsh"
    chsh -s $(which zsh)
fi

# Install oh-my-zsh
oh_my_zsh_dir="$HOME/.oh-my-zsh"
if ! directory_exists "$oh_my_zsh_dir"; then
    printf "Installing oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    printf "oh-my-zsh is already installed at $oh_my_zsh_dir"
fi