#!/usr/bin/env fish
# fish completion support for 🔥lume vv3.0.2

function __fish___lume_using_command
  set -l cmds ____lume ____lume_new ____lume_upgrade ____lume_run ____lume_cms ____lume_completions ____lume_completions_bash ____lume_completions_fish ____lume_completions_zsh
  set -l words (commandline -opc)
  set -l cmd "_"
  for word in $words
    switch $word
      case '-*'
        continue
      case '*'
        set word (string replace -r -a '\W' '_' $word)
        set -l cmd_tmp $cmd"_$word"
        if contains $cmd_tmp $cmds
          set cmd $cmd_tmp
        end
    end
  end
  if test "$cmd" = "$argv[1]"
    return 0
  end
  return 1
end

complete -c 🔥lume -n '__fish___lume_using_command ____lume' -s h -l help -x -k -f -d 'Show this help.'
complete -c 🔥lume -n '__fish___lume_using_command ____lume' -s V -l version -x -k -f -d 'Show the version number for this program.'
complete -c 🔥lume -n '__fish___lume_using_command ____lume' -l config -k -f -r -a '(🔥lume completions complete string )' -d 'The config file path.'
complete -c 🔥lume -n '__fish___lume_using_command ____lume' -l src -k -f -r -a '(🔥lume completions complete string )' -d 'The source directory for your site.'
complete -c 🔥lume -n '__fish___lume_using_command ____lume' -l dest -k -f -r -a '(🔥lume completions complete string )' -d 'The build destination.'
complete -c 🔥lume -n '__fish___lume_using_command ____lume' -l location -k -f -r -a '(🔥lume completions complete string )' -d 'The URL location of the site.'
complete -c 🔥lume -n '__fish___lume_using_command ____lume' -s s -l serve -k -f -d 'Start a live-reloading web server and watch changes.'
complete -c 🔥lume -n '__fish___lume_using_command ____lume' -s p -l port -k -f -r -a '(🔥lume completions complete number )' -d 'The port where the server runs.'
complete -c 🔥lume -n '__fish___lume_using_command ____lume' -l hostname -k -f -r -a '(🔥lume completions complete string )' -d 'The hostname where the server runs.'
complete -c 🔥lume -n '__fish___lume_using_command ____lume' -s o -l open -k -f -d 'Open the site in a browser.'
complete -c 🔥lume -n '__fish___lume_using_command ____lume' -s w -l watch -k -f -d 'Build and watch changes.'
complete -c 🔥lume -n '__fish___lume_using_command ____lume' -k -f -a new -d 'Run an archetype to create more files.'
complete -c 🔥lume -n '__fish___lume_using_command ____lume_new' -k -f -a '(🔥lume completions complete string new)'
complete -c 🔥lume -n '__fish___lume_using_command ____lume_new' -s h -l help -x -k -f -d 'Show this help.'
complete -c 🔥lume -n '__fish___lume_using_command ____lume' -k -f -a upgrade -d 'Upgrade your Lume executable to the latest version.'
complete -c 🔥lume -n '__fish___lume_using_command ____lume_upgrade' -s h -l help -x -k -f -d 'Show this help.'
complete -c 🔥lume -n '__fish___lume_using_command ____lume_upgrade' -l version -k -f -r -a '(🔥lume completions complete string upgrade)' -d 'The version to upgrade to.'
complete -c 🔥lume -n '__fish___lume_using_command ____lume_upgrade' -s d -l dev -k -f -d 'Install the latest development version (last Git commit).'
complete -c 🔥lume -n '__fish___lume_using_command ____lume' -k -f -a run -d 'Run one or more scripts from the config file.'
complete -c 🔥lume -n '__fish___lume_using_command ____lume_run' -k -f -a '(🔥lume completions complete string run)'
complete -c 🔥lume -n '__fish___lume_using_command ____lume_run' -s h -l help -x -k -f -d 'Show this help.'
complete -c 🔥lume -n '__fish___lume_using_command ____lume_run' -l config -k -f -r -a '(🔥lume completions complete string run)' -d 'The config file path.'
complete -c 🔥lume -n '__fish___lume_using_command ____lume_run' -l src -k -f -r -a '(🔥lume completions complete string run)' -d 'The source directory for your site.'
complete -c 🔥lume -n '__fish___lume_using_command ____lume_run' -l dest -k -f -r -a '(🔥lume completions complete string run)' -d 'The build destination.'
complete -c 🔥lume -n '__fish___lume_using_command ____lume_run' -l location -k -f -r -a '(🔥lume completions complete string run)' -d 'The URL location of the site.'
complete -c 🔥lume -n '__fish___lume_using_command ____lume' -k -f -a cms -d 'Run Lume CMS.'
complete -c 🔥lume -n '__fish___lume_using_command ____lume_cms' -s h -l help -x -k -f -d 'Show this help.'
complete -c 🔥lume -n '__fish___lume_using_command ____lume_cms' -l config -k -f -r -a '(🔥lume completions complete string cms)' -d 'The config file path.'
complete -c 🔥lume -n '__fish___lume_using_command ____lume_cms' -l src -k -f -r -a '(🔥lume completions complete string cms)' -d 'The source directory for your site.'
complete -c 🔥lume -n '__fish___lume_using_command ____lume_cms' -l dest -k -f -r -a '(🔥lume completions complete string cms)' -d 'The build destination.'
complete -c 🔥lume -n '__fish___lume_using_command ____lume_cms' -l location -k -f -r -a '(🔥lume completions complete string cms)' -d 'The URL location of the site.'
complete -c 🔥lume -n '__fish___lume_using_command ____lume_cms' -s p -l port -k -f -r -a '(🔥lume completions complete number cms)' -d 'The port where the server runs.'
complete -c 🔥lume -n '__fish___lume_using_command ____lume_cms' -l hostname -k -f -r -a '(🔥lume completions complete string cms)' -d 'The hostname where the server runs.'
complete -c 🔥lume -n '__fish___lume_using_command ____lume_cms' -s o -l open -k -f -d 'Open the CMS in a browser.'
complete -c 🔥lume -n '__fish___lume_using_command ____lume' -k -f -a completions -d 'Generate shell completions.'
complete -c 🔥lume -n '__fish___lume_using_command ____lume_completions' -s h -l help -x -k -f -d 'Show this help.'
complete -c 🔥lume -n '__fish___lume_using_command ____lume_completions' -k -f -a bash -d 'Generate shell completions for bash.'
complete -c 🔥lume -n '__fish___lume_using_command ____lume_completions_bash' -s h -l help -x -k -f -d 'Show this help.'
complete -c 🔥lume -n '__fish___lume_using_command ____lume_completions' -k -f -a fish -d 'Generate shell completions for fish.'
complete -c 🔥lume -n '__fish___lume_using_command ____lume_completions_fish' -s h -l help -x -k -f -d 'Show this help.'
complete -c 🔥lume -n '__fish___lume_using_command ____lume_completions' -k -f -a zsh -d 'Generate shell completions for zsh.'
complete -c 🔥lume -n '__fish___lume_using_command ____lume_completions_zsh' -s h -l help -x -k -f -d 'Show this help.'
