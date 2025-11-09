# Dotfiles

This repository contains configuration files and resources for personalizing and optimizing your development environment.

## Contents

### Configurations
- **.zshrc**: Primary configuration file for the Zsh shell, which includes custom aliases, functions, and plugin management.

### Themes
- **catppuccin-mocha.itermcolors**: A color scheme designed for iTerm2 to enhance the terminal's aesthetics and readability.

### Visual Elements
- **Wallpapers**: A collection of wallpapers to personalize your desktop environment, located in the [`wallpapers/`](https://github.com/SneachChea/dotfiles/tree/main/wallpapers) directory.

## Plugins Installation

To enhance your shell experience, the `.zshrc` file uses the following plugins:
- `git`
- `fzf`
- `zsh-completions`
- `zsh-autosuggestions`
- `zsh-syntax-highlighting`

Ensure these plugins are installed and properly set up in your system.

## How to Use

1. Clone the repository:
   ```bash
   git clone https://github.com/SneachChea/dotfiles.git
   ```
2. Copy or link the desired configuration files to your home directory. For example:
   ```bash
   ln -s dotfiles/.zshrc ~/.zshrc
   ```
3. Customize and apply the [Catppuccin Mocha](https://github.com/SneachChea/dotfiles/blob/main/catppuccin-mocha.itermcolors) color scheme in iTerm2:
   - Open iTerm2, go to `Preferences > Profiles > Colors`.
   - Import `catppuccin-mocha.itermcolors` and apply.

4. Use the wallpapers to enhance your desktop background.

## Customization
Feel free to modify these files to suit your specific preferences and workflow.

## Contributions
This repository is tailored for personal use, but suggestions or ideas are welcome. Open an issue to discuss proposed changes.