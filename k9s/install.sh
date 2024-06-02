source "$(dirname "${BASH_SOURCE[0]}")/../install/utils.sh"
# Install k9s cli
brew_install "derailed/k9s/k9s"
# Install k9s cattpuccin themes (https://github.com/catppuccin/k9s) to $DOTFILES/config/skins folder
OUTPUT_DIR="${DOTFILES}/k9s/config/skins"
curl -sL https://github.com/catppuccin/k9s/archive/main.tar.gz | tar x -C "$OUTPUT_DIR" --strip-components=2 k9s-main/dist
