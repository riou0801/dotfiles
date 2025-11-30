function ime
    sleep 0.1
    fcitx5-remote -o
    read --line --prompt-str='✒ …' | wl-copy
    fcitx5-remote -c
end
