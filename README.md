# Dotfiles

Repository containing the "dotfiles", or tools and configuration, that are used in my development environment. It also includes scripts to automate the installation and configuration of these tools, and the system, to ensure a similar experience across any machine.

## Table of Contents

- [Organization](#organization)
  - [install folder](#install-folder)
  - [dotfile / tool folders](#dotfile--tool-folders)
- [Installation](#installation)
- [Footnotes](#footnotes)
  - [Local ZSH Config](#local-zsh-config)
  - [Updating Submodules](#updating-submodules)

## Organization

The repository is organized as follows:

```
dotfiles/
├── tool/
│   ├── config/
│   │   └── **
│   ├── install.sh
│   └── links.prop
├── install/
│   └── setup.sh
├── .gitignore
├── .gitmodules
└── README.md
```

### install folder
The `install` directory contains a `setup.sh` and supporting shell scripts to set up a system for development with specific tools / applications.

### dotfile / tool folders
Each "dotfile", or tool and its configuration, is contained in its own folder inside the root directory (shown above as `tool`). To be configured on the system by the setup script, each dotfile folder should have:

| File | Description |
|---|---|
| `config/**` | All the files (can be in subdirectories) that make up the configuration for the tool. |
| `install.sh` | Shell script to install the tool on the system. |
| `links.prop` | Property file for creating symbolic links for configs. Each line should contain a single key-value pair in the form `SOURCE_PATH=DESTINATION_PATH`. Typically the `SOURCE_PATH` would be the path to the configuration file or directory in this directory, and the `DESTINATION_PATH` would be the path on the system where the configuration for that tool would normally live. This way, configuration can be managed from this repository and tracked in source control.  |
| `post_setup.sh` | Optional. Shell script to run any post-configuration steps for the tool. This is run after the install script for the tool and the creation of its symlinks. |

On setup, each dotfile is configured as follows:

1. If it exists, the `install.sh` script is run to install the tool.
2. If it exists, symbolic links are created between the source and destination paths enumerated in the `links.prop` file.
3. If it exists, the `post_setup.sh` script is run to perform post-installation steps.

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

3. If you are on macOS: in the Alacritty terminal config, update the shell
    configuration to use the `login` process with your username as the second
    arg (`echo $USERNAME` to print your username). On macOS, the default process
    for a shell should use `login -fp $USERNAME` and not a direct invocation of
    `/bin/bash`.

    `alacritty/config/alacritty.toml`:
    ```toml
    [shell]
    args = ["-fp", "hasibr"]
    program = "login"
    ```

4. Run the setup script.

    ```sh
    chmod +x ./install/setup.sh
    ./install/setup.sh
    ```

## Update

### Update Git Submodules and Push to Remote

After the first time setup, you can update the Git submodules to the latest versions by running:

```sh
git submodule update --recursive --remote
```

Then stage, commit, and push the submodule changes to this repository.

### Pull Latest Dotfiles from Remote

To pull the latest changes to this repository and sync the local Git submodules with those in the
remote Dotfiles repository:

```sh
git pull --rebase && \
  git submodule update --recursive
```

### Update Neovim Configuration

If Neovim configuration is changed, this may sometimes require a reinstall of the packages to ensure expected behaviour. To have all the packages reinstalled on Neovim startup, clear the Neovim local caches and start Neovim again:

```sh
rm -rf ~/.local/share/nvim \
  && rm -rf ~/.cache/nvim \
  && nvim
```

## Footnotes

### Local ZSH Config

If there's customization you want ZSH to load on startup that is specific to
this machine (stuff you don't want to commit into the repo), create `~/.env.sh`
and put it in there. It will be loaded near the top of `.zshrc`.

### Yabai

Some features of the window management utility Yabai require System Integrity
Protection (SIP) on macOS to be disabled. This may be required during first time
setup. Refer to Yabai's installation documentation for instructions: [link](https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection).

Afterwards, as Yabai is ugpraded (e.g. via Homebrew, see [upgrade instructions](https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(latest-release)#updating-to-the-latest-release)),
the SHA256 hash of the new yabai binary must be updated in the configuration entry.
This can be done by running this command or re-running the setup script:

```sh
echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | cut -d " " -f 1) $(which yabai) --load-sa" | sudo tee /private/etc/sudoers.d/yabai
```
