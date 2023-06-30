# Dotfiles

## Prerequisites

Update the shell entry with your username (`echo $USERNAME`).

```yaml
shell:
  # Default process for a shell on macOS should use login -fp $USERNAME and not a direct invocation of /bin/bash
  program: login
  args: ["-fp", "hasibr"]
```

## Install

```
git clone git@github.com:hasibr/dotfiles.git
cd dotfiles
chmod +x ./install/setup.sh
./install/setup.sh
```

## Local ZSH Config

If there's customization you want ZSH to load on startup that is specific to 
this machine (stuff you don't want to commit into the repo), create `~/.env.sh`
and put it in there. It will be loaded near the top of `.zshrc`.

