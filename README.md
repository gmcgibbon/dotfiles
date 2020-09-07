## Dotfiles

#### What's included

- [Zsh configuration](zshrc)
- [Vim configuration](vimrc)
- [Git configuration](gitconfig)
- [Rubocop configuration](rubocop.yml)
- Cross platform bootstrap script ([mac](bin/bootstrap/macos), [debian](bin/bootstrap/linux), [windows](bin/bootstrap/windows.bat))
- Application bootstrap ([list](Bootstrapfile))

#### Installation

1. Clone the repo:

```sh
git clone https://github.com/gmcgibbon/dotfiles ~/dotfiles
```

2. Run this the bootstrap script for your platform:

```sh
~/dotfiles/bin/bootstrap/{platform} # where {platform} is your OS
```

3. Change your shell to `zsh`:

```sh
chsh -s $(which zsh)
```
