# ----- Personal aliases
# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# ALIASES ---------------------------------------------------------------------
alias unmount_all_and_exit='unmount_all && exit'
alias d=docker
alias dc=docker-compose
alias dkill="pgrep \"Docker\" | xargs kill -9"
alias hcat='highlight -O ansi'

alias vi='nvim -w ~/.vimlog "$@"'
alias vim='nvim -w ~/.vimlog "$@"'

# alias zn='vim $NOTES_DIR/$(date +"%Y%m%d%H%M.md")'

# Aliases for tmux
alias ta='tmux attach -t'
alias tks='tmux kill-session -t'

# Aliases for exa - replacements for ls and la.
# Tree view: lt <depth> (default is 1)
if [ -x "$(command -v eza)" ]; then
    alias ls="eza --long --icons --all"
    alias la="eza --long --header --all --group --icons"
    lt() { eza -alhT --icons --grid --git -I'.git|node_modules|.mypy_cache|.pytest_cache|.venv' --color=always "-L${1:-1}" | less -R }
fi
alias c='clear'
alias s='source ~/.zshrc'
alias jj='pbpaste | jsonpp | pbcopy'
alias trim="awk '{\$1=\$1;print}'"

# awsp - aws profile switcher: https://github.com/johnnyopao/awsp
# __awsp is a custom wrapper around the original _awsp executable
alias awsp="source $HOME/__awsp"

# GIT ALIASES -----------------------------------------------------------------
# Lazygit, simple terminal UI for git commands. https://github.com/jesseduffield/lazygit
alias lg='CONFIG_DIR="$HOME/.config/lazygit" lazygit'

alias gc='git commit'
alias gco='git checkout'
alias ga='git add'
alias gb='git branch'
alias gba='git branch --all'
alias gbd='git branch -D'
alias gcp='git cherry-pick'
alias gd='git diff -w'
alias gds='git diff -w --staged'
alias grs='git restore --staged'
alias gst='git rev-parse --git-dir > /dev/null 2>&1 && git status || exa'
alias gu='git reset --soft HEAD~1'
alias gpr='git remote prune origin'
alias ff='gpr && git pull --ff-only'
alias grd='git fetch origin && git rebase origin/master'
alias gbb='git-switchbranch'
alias gbf='git branch | head -1 | xargs' # top branch
alias gl=pretty_git_log
alias gla=pretty_git_log_all
#alias gl="git log --graph --format=format:'%C(bold blue)%h%C(reset) - %C(white)%s%C(reset) %C(green)%an %ar %C(reset) %C(bold magenta)%d%C(reset)'"
#alias gla="git log --all --graph --format=format:'%C(bold blue)%h%C(reset) - %C(white)%s%C(reset) %C(bold magenta)%d%C(reset)'"
alias git-current-branch="git branch | grep \* | cut -d ' ' -f2"
alias grc='git rebase --continue'
alias gra='git rebase --abort'
alias gec='git status | grep "both modified:" | cut -d ":" -f 2 | trim | xargs nvim -'
alias gcan='gc --amend --no-edit'

alias gp="git push -u 2>&1 | tee >(cat) | grep \"pull/new\" | awk '{print \$2}' | xargs open"
alias gpf='git push --force-with-lease'

alias gbdd='git-branch-utils -d'
alias gbuu='git-branch-utils -u'
alias gbrr='git-branch-utils -r -b develop'
alias gg='git branch | fzf | xargs git checkout'
alias gup='git branch --set-upstream-to=origin/$(git-current-branch) $(git-current-branch)'

alias gnext='git log --ancestry-path --format=%H ${commit}..master | tail -1 | xargs git checkout'
alias gprev='git checkout HEAD^'

# FUNCTIONS -------------------------------------------------------------------
# function gg {
#     git branch | grep "$1" | head -1 | xargs git checkout
# }

function take {
    mkdir -p $1
    cd $1
}

note() {
    echo "date: $(date)" >> $HOME/drafts.txt
    echo "$@" >> $HOME/drafts.txt
    echo "" >> $HOME/drafts.txt
}

function unmount_all {
    diskutil list |
    grep external |
    cut -d ' ' -f 1 |
    while read file
    do
        diskutil unmountDisk "$file"
    done
}

mff ()
{
    local curr_branch=`git-current-branch`
    gco master
    ff
    gco $curr_branch
}

JOBFILE="$DOTFILES/job-specific.sh"
if [ -f "$JOBFILE" ]; then
    source "$JOBFILE"
fi

# Docker aliases / functions
dclear () {
    docker ps -a -q | xargs docker kill -f
    docker ps -a -q | xargs docker rm -f
    docker images | grep "api\|none" | awk '{print $3}' | xargs docker rmi -f
    docker volume prune -f
}

alias docker-clear=dclear
alias lzd='lazydocker'

dreset () {
    dclear
    docker images -q | xargs docker rmi -f
    docker volume rm $(docker volume ls |awk '{print $2}')
    rm -rf ~/Library/Containers/com.docker.docker/Data/*
    docker system prune -a
}

extract-audio-and-video () {
    ffmpeg -i "$1" -c:a copy obs-audio.aac
    ffmpeg -i "$1" -c:v copy obs-video.mp4
}

hs () {
 curl https://httpstat.us/$1
}

# alias dp='displayplacer "id:83F2F7DC-590D-6294-B7FB-521754A2A693 res:3840x2160 hz:60 color_depth:8 scaling:off origin:(0,0) degree:0" "id:BD0804E4-6EAA-1C8D-1CFB-D6B734DE10A5 res:3840x2160 hz:60 color_depth:8 scaling:off origin:(3840,0) degree:0"'
# alias mirror-displays='displayplacer "id:C3F5FA73-E883-4B6D-88B3-DA6D6A8192B3+7ECC0B33-A07B-46A6-AFB8-565FEFE68216 res:3840x2160 hz:60 color_depth:8 scaling:off origin:(0,0) degree:0"'

copy-line () {
  rg --line-number "${1:-.}" | sk --delimiter ':' --preview 'bat --color=always --highlight-line {2} {1}' | awk -F ':' '{print $3}' | sed 's/^\s+//' | pbcopy
}

open-at-line () {
  vim $(rg --line-number "${1:-.}" | sk --delimiter ':' --preview 'bat --color=always --highlight-line {2} {1}' | awk -F ':' '{print "+"$2" "$1}')
}

#######################################
# Formats all Shell (.sh) scripts in the current and subdirectories using shfmt.
# Runs `shfmt` inside a Docker container and applies formatting according
# to Google's Shell Style Guide.
# Options used:
# - `-i 2`: Indent with 2 spaces instead of tabs.
# - `-ci`: Indent switch cases.
# - `-w`: Write changes to files.
# Globals:
#   PWD
# Arguments:
#   None
# Returns:
#   0 if formatting succeeds, non-zero otherwise.
#######################################
format_shell_scripts() {
  printf "Formatting *.sh files in directory (and sub-directories): %s\n..." "$PWD"
  docker run --rm \
    --platform linux/amd64 \
    --volume="$PWD":"/work" \
    tmknom/shfmt -i 2 -ci -w **/*.sh
  local exit_code=$?
  print_if_success $exit_code "Done." "Error formatting *.sh files."
}

#######################################
# Prints a success or failure message based on the exit status of the last command.
# Globals:
#   None
# Arguments:
#   $1 - Exit status of the command to evaluate.
#   $2 - Message to print if the previous command succeeded.
#   $3 - Message to print if the previous command failed.
# Returns:
#   0
#######################################
print_if_success() {
  local exit_code
  local success
  local fail
  exit_code=$1
  success="$2"
  fail="$3"
  if [ "$exit_code" -eq 0 ]; then
    printf "%s\n" "$success"
  else
    printf "%s\n" "$fail"
  fi
}

alias shfmt=format_shell_scripts
