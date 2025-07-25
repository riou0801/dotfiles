if status is-interactive
    # Commands to run in interactive sessions can go here
    #set proxy_host 172.16.1.2:15080
    #set proxy_auth false

    fzf_configure_bindings --directory=\cf

    #abbr
    abbr -a exa eza -T --all --icons --color=always
    abbr -a ls eza -l
    abbr -a fd fd -Hg
    abbr -a pacs sudo pacman -Syu --noconfirm
    abbr -a yacs yay -Syua --noconfirm
    abbr -a bat bat --color always
    abbr -a du dust -r
    #abbr -a er erd --disk-usage logical --level 2 --human --icons --sort size --layout inverted --dir-order first
    abbr -a erd erd -H -I -i -P --hidden --layout inverted --dir-order first --level 2
    abbr -a tclock tclock --color '#a6adc8'
    abbr -a sude sudo -E helix
    abbr -a zg 'z $(ghq root)/$(ghq list | fzf --height 30 --preview "eza -1 -T --icons --sort name --color always $(ghq root)/{}" --layout reverse --border rounded)'
    abbr -a nvim-test env NVIM_APPNAME=nvim-test nvim
    abbr -a ghn env GHQ_ROOT=$HOME/.config/nvim-test/pack ghq
    # abbr -a spt spt; and systemctl --user restart spotifyd.service
    abbr -a diff diff -u --color
    abbr -a zed zeditor
    abbr -a hx helix
    abbr -a yas yay -Ss
    abbr -a pas pacman -Ss
end

zoxide init fish | source
aliae init fish --config "/home/riou/.config/aliae/aliae.yaml" | source
