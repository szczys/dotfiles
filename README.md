# Szczys Dotfiles

Personal dotfiles of Mike Szczys. Thank you to all who have shared their tips,
tricks, and configuration files online. I have learned everything I know from a
vast community of Linux aficionados.

## References

The patterns used to version control my dotfiles are based on:

* Patrick Gaskin: [How to manage your dotfiles using
  Git](https://pgaskin.net/posts/git-dotfiles/)
* Gabrielle Young: [The best way to store your dotfiles: A bare Git repository
  **EXPLAINED**](https://www.ackama.com/what-we-think/the-best-way-to-store-your-dotfiles-a-bare-git-repository-explained/)

## Import these dotfiles on a new system

1. `cd`
2. `echo ".cfg" >> .gitignore`
3. `git clone <remote-git-repo-url> $HOME/.cfg`
4. `alias config='/usr/bin/git --git-dir=$HOME/.cfg/.git --work-tree=$HOME'`
5. `config config --local status.showUntrackedFiles no`
6. `config checkout`

## Install dependencies

```
# Using Fish shell
sudo apt install fish
curl -sS https://starship.rs/install.sh | sh

# Tmux Plugin Manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# Press Leader+I to install plugins

# Install nvm
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
fisher install jorgebucaran/nvm.fish

```


