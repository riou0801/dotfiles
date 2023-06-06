# dotfiles
- dotfiles with chezmoi
- env
  - [Crystal linux](https://getcryst.al/site)
  - [Sway](https://swaywm.org/) + [nwg-shell](https://nwg-piotr.github.io/nwg-shell/)
  - [foot](https://codeberg.org/dnkl/foot)
  - [fish](https://fishshell.com/)
  - [helix-editor](https://helix-editor.com/)
  
## [daily workup](https://www.chezmoi.io/user-guide/daily-operations/)

  1. `chezmoi update` # this runs `git pull --autostash --rebase`
  2. `chezmoi add ~/path/to/config`
  3. `chezmoi apply`
  4. `chezmoi cd` or `chezmoi git -- [args]`
  5. ```git add .  git commit -m "commit message"  git push -u origin main
     ```
  6. `exit` # finish subshell

## sync the config
  - `chezmoi init https://github.com/myrepo/dotfiles.git`
  - `chezmoi apply`
  or
  `chezmoi init --apply https://github.com/$GITHUB_USERNAME/dotfiles.git`