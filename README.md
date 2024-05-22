# ezsh
A simple script to setup an awesome shell environment.
Quickly install and setup zsh and [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) with
* [powerlevel10k](https://github.com/romkatv/powerlevel10k) theme
* [Nerd-Fonts](https://github.com/ryanoasis/nerd-fonts)
* [zsh-completions](https://github.com/zsh-users/zsh-completions)
* [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
* [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
* [history-substring-search](https://github.com/zsh-users/zsh-history-substring-search)
* [fzf](https://github.com/junegunn/fzf)
* [k](https://github.com/supercrabtree/k)
* [todotxt](https://github.com/todotxt/todo.txt-cli)

Sets following useful aliases and ohmyzsh plugins.
* l="ls -lah"         - just type "l" instead of "ls -lah"
* alias k="k -h"	  - show human readable filesizes, in kb, mb etc
* e="exit"
* [x="extract"](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/extract)         - extract any compressed files
* [z](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/z)   - quickly jump to most visited directories
* [web-search](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/web-search)    - search on the web from cli
* [sudo](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/sudo)                - easily prefix your commands with sudo by pressing `esc` twice
* [systemd](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/systemd)          - many useful aliases for systemd
* https               - make httpie use https
* myip - (wget -qO- https://wtfismyip.com/text)       - what's my ip: quickly find out external IP
* cheat - (https://github.com/chubin/cheat.sh)        - cheatsheets in the terminal!
* dict - (curl "dict://dict.org/d:$1 $2 $3")          - dictionary definitions
* ipgeo - (curl "http://api.db-ip.com/v2/free/$1")    - finds geo location from IP

## Demo
[![asciicast](https://asciinema.org/a/225226.svg)](https://asciinema.org/a/225226)

