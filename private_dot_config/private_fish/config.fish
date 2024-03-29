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
    abbr -a yacs yay -Syua
	abbr -a bat bat --color always
	abbr -a du dust -r
	#abbr -a er erd --disk-usage logical --level 2 --human --icons --sort size --layout inverted --dir-order first
    abbr -a erd erd -H -I -i -P --hidden --layout inverted --dir-order first  --level 2
	abbr -a tclock tclock --color '#a6adc8'
    abbr -a sude sudo -E helix
    abbr -a vsnvim env NVIM_APPNAME=vsnvim nvim
    abbr -a nvchad env NVIM_APPNAME=nvchad nvim
end

zoxide init fish | source
aliae init fish --config "/home/riou/.config/aliae/aliae.yaml" | source
