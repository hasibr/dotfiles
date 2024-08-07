# ---------- zsh configuration ----------

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# Set name of the theme to load
ZSH_THEME="powerlevel10k/powerlevel10k"

source_if_exists () {
    if test -r "$1"; then
        source "$1"
    fi
}

# Powerlevel10k prompt. To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
source_if_exists "$HOME/.p10k.zsh"
# Custom ZSH configuration that will not be checked into source control
source_if_exists "$HOME/.env.sh"
# oh-my-zsh history
source_if_exists "$DOTFILES/zsh/config/history.zsh"
# Git utility functions (e.g. pretty git log)
source_if_exists "$DOTFILES/zsh/config/git.zsh"
# fzf, command-line fuzzy finder
source_if_exists "$HOME/.fzf.zsh"
# asdf executable
export ASDF_CONFIG_FILE="$HOME/.config/asdf/asdfrc"
source_if_exists "$HOME/.asdf/asdf.sh"
source_if_exists "/usr/local/etc/profile.d/z.sh"
source_if_exists "/opt/homebrew/etc/profile.d/z.sh"

# Initialize completions
# Append completions to fpath
# asdf auto-completions
fpath=(${ASDF_DIR}/completions $fpath)
# Initialise completions with ZSH's compinit
autoload -Uz compinit
# Note: fpath must be fully built before calling compinit
compinit
eval "$(zoxide init zsh)"

# oh-my-zsh auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time
# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	git
	zsh-autosuggestions
	zsh-syntax-highlighting
)

source_if_exists "$ZSH/oh-my-zsh.sh"

# ---------- User configurations ----------

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

export VISUAL=nvim
export EDITOR=nvim

# asdf configuration
# Path to the .asdfrc configuration file
export ASDF_CONFIG_FILE="$HOME/.config/asdf/asdfrc"

# asdf plugins
# dotnet-core (https://github.com/emersonsoares/asdf-dotnet-core)
# Script to set DOTNET_ROOT environment variable
. "$ASDF_DIR/plugins/dotnet-core/set-dotnet-home.zsh"
# Go (https://github.com/kennyp/asdf-golang)
# Script to set GOROOT variable
# . "$ASDF_DIR/plugins/golang/set-env.zsh"

# k9s configuration
# Path to the k9s configuration folder
export K9S_CONFIG_DIR="$HOME/.config/k9s"

# Go configuration
# Version selection: When using .tool-versions or .go-version, the exact
# version specified in the file will be selected. When using go.mod, the
# highest compatible version that is currently installed will be selected.
# Include go.mod and go.work for version selection.
export ASDF_GOLANG_MOD_VERSION_ENABLED=true

# Path
# Add tee-clc directory to enable "tf" command
export PATH="$PATH:$HOME/.tee-clc"
# Add Rancher Desktop to path
export PATH="$PATH:$HOME/.rd/bin"
# Add dotnet tools directory to path
export PATH="$PATH:$HOME/.dotnet/tools"
# Add GOPATH ("$ASDF_DIR/installs/golang/<version>/packages/bin") to the path
export PATH="$PATH:$(go env GOPATH)/bin"
# Add postgresql@16 (psql) to path
export PATH="$PATH:/opt/homebrew/opt/postgresql@16/bin"

# ----- Personal aliases
# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
source_if_exists "$DOTFILES/zsh/config/aliases.zsh"
# -----

# ----- Section below is managed by other applications

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba init' !!
export MAMBA_EXE="/opt/homebrew/opt/micromamba/bin/micromamba";
export MAMBA_ROOT_PREFIX="/Users/hrahman/micromamba";
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    if [ -f "/Users/hrahman/micromamba/etc/profile.d/micromamba.sh" ]; then
        . "/Users/hrahman/micromamba/etc/profile.d/micromamba.sh"
    else
        export  PATH="/Users/hrahman/micromamba/bin:$PATH"  # extra space after export prevents interference from conda init
    fi
fi
unset __mamba_setup
# <<< mamba initialize <<<
