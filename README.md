# Dotfiles

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

