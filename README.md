# Dotfiles



## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Footnotes](#footnotes)
  - [Local ZSH Config](#local-zsh-config)

## Prerequisites

Update the shell entry with your username (`echo $USERNAME` to print your username).

```yaml
shell:
  # Default process for a shell on macOS should use login -fp $USERNAME and not a direct invocation of /bin/bash
  program: login
  args: ["-fp", "hasibr"]
```

## Installation

1. Clone this repository.

    ```sh
    git clone git@github.com:hasibr/dotfiles.git $HOME/dotfiles \
      && cd $HOME/dotfiles
    ```

2. Pull in the latest submodules defined in the repository.

    ```sh
    git submodule update --init --recursive
    ```

    The `--init` flag initializes any new submodules that might have been added, and the `--recursive` flag ensures that nested submodules are also updated.

    After the first time setup, you can update the submodules to the latest versions with the following:

    ```sh
    git submodule update --recursive
    ```

3. Run the installation script (`setup.sh`).

    ```sh
    chmod +x ./install/setup.sh
    ./install/setup.sh
    ```

## Footnotes

### Local ZSH Config

If there's customization you want ZSH to load on startup that is specific to 
this machine (stuff you don't want to commit into the repo), create `~/.env.sh`
and put it in there. It will be loaded near the top of `.zshrc`.

