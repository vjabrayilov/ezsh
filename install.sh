#!/bin/bash

cp_hist_flag=false
noninteractive_flag=true

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'

for arg in "$@"
do
    case $arg in
        --cp-hist|-c)
            cp_hist_flag=true
            ;;
        --non-interactive|-n)
            noninteractive_flag=true
            ;;
        *)
            # Handle any other arguments or provide an error message
            ;;
    esac
done

function install_dependencies {
    if command -v zsh &>/dev/null && command -v git &>/dev/null && command -v wget &>/dev/null; then
        echo -e "${YELLOW}zsh, git, wget are already installed\n${NC}"
    else
        if sudo apt install -y zsh git wget autoconf &>/dev/null || sudo brew install git zsh wget &>/dev/null; then
            echo -e "${GREEN}zsh, git, wget are installed\n${NC}"
        else
            echo -e "${RED}Failed to install  zsh git wget, plese install manually \n${NC}" && exit
        fi
    fi
}

function backup_old_configs {
    if mv -n "${HOME}/.zshrc" "${HOME}/.zshrc-backup-${DATE}"; then
        echo -e "${YELLOW}Backed up the current .zshrc to .zshrc-backup-${DATE}\n${NC}"
    else
        echo -e "${YELLOW}No existing .zshrc found\n${NC}"
    fi
}

function ezsh_dir_structure {
    echo -e "${YELLOW}The setup will be installed in '${HOME}/.config/ezsh'\n
        Place your personal zshrc config files under '${HOME}/.config/ezsh/zshrc/'\n${NC}"

    mkdir -p ~/.config/ezsh/zshrc # PLACE YOUR ZSHRC CONFIGURATIONS OVER THERE
    mkdir -p ~/.cache/zsh/        # this will be used to store .zcompdump zsh completion cache files which normally clutter $HOME
    mkdir -p ~/.fonts             # Create .fonts if doesn't exist

    cp -f .zshrc ~/
    cp -f ezshrc.zsh ~/.config/ezsh/
}

function instal_omz {
    echo -e "${YELLOW}Installing oh-my-zsh\n${NC}"
    if [ -d ~/.config/ezsh/oh-my-zsh ]; then
        echo -e "${GREEN}oh-my-zsh is already installed\n${NC}"
        git -C ~/.config/ezsh/oh-my-zsh remote set-url origin https://github.com/ohmyzsh/ohmyzsh.git
    elif [ -d ~/.oh-my-zsh ]; then
        echo -e "${GREEN}oh-my-zsh in already installed at '~/.oh-my-zsh'. Moving it to '~/.config/ezsh/oh-my-zsh'${NC}"
        export ZSH="$HOME/.config/ezsh/oh-my-zsh"
        mv ~/.oh-my-zsh ~/.config/ezsh/oh-my-zsh
        git -C ~/.config/ezsh/oh-my-zsh remote set-url origin https://github.com/ohmyzsh/ohmyzsh.git
    else
        git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git ~/.config/ezsh/oh-my-zsh
    fi
    cp -f p10k.zsh ~/.config/ezsh/
}


function setup_zcompdump {
    if [ -f ~/.zcompdump ]; then
        mv ~/.zcompdump* ~/.cache/zsh/
    fi
}

function install_omz_plugins {
    if [ -d ~/.config/ezsh/oh-my-zsh/plugins/zsh-autosuggestions ]; then
        cd ~/.config/ezsh/oh-my-zsh/plugins/zsh-autosuggestions && git pull
    else
        git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ~/.config/ezsh/oh-my-zsh/plugins/zsh-autosuggestions
    fi

    if [ -d ~/.config/ezsh/oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
        cd ~/.config/ezsh/oh-my-zsh/custom/plugins/zsh-syntax-highlighting && git pull
    else
        git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.config/ezsh/oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    fi

    if [ -d ~/.config/ezsh/oh-my-zsh/custom/plugins/zsh-completions ]; then
        cd ~/.config/ezsh/oh-my-zsh/custom/plugins/zsh-completions && git pull
    else
        git clone --depth=1 https://github.com/zsh-users/zsh-completions ~/.config/ezsh/oh-my-zsh/custom/plugins/zsh-completions
    fi

    if [ -d ~/.config/ezsh/oh-my-zsh/custom/plugins/zsh-history-substring-search ]; then
        cd ~/.config/ezsh/oh-my-zsh/custom/plugins/zsh-history-substring-search && git pull
    else
        git clone --depth=1 https://github.com/zsh-users/zsh-history-substring-search ~/.config/ezsh/oh-my-zsh/custom/plugins/zsh-history-substring-search
    fi
}


function install_fonts {
    echo -e "${YELLOW}Installing Nerd Fonts version of Hack, Roboto Mono, DejaVu Sans Mono\n${NC}"

    wget -q --show-progress -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/HackNerdFont-Regular.ttf -P ~/.fonts/
    wget -q --show-progress -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/RobotoMono/Regular/RobotoMonoNerdFont-Regular.ttf -P ~/.fonts/
    wget -q --show-progress -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DejaVuSansMono/Regular/DejaVuSansMNerdFont-Regular.ttf -P ~/.fonts/

    fc-cache -fv ~/.fonts
}

function install_p10k {
    if [ -d ~/.config/ezsh/oh-my-zsh/custom/themes/powerlevel10k ]; then
        cd ~/.config/ezsh/oh-my-zsh/custom/themes/powerlevel10k && git pull
    else
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.config/ezsh/oh-my-zsh/custom/themes/powerlevel10k
    fi
}

function install_fzf {
    if [ -d ~/.~/.config/ezsh/fzf ]; then
        cd ~/.config/ezsh/fzf && git pull
        ~/.config/ezsh/fzf/install --all --key-bindings --completion --no-update-rc
    else
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.config/ezsh/fzf
        ~/.config/ezsh/fzf/install --all --key-bindings --completion --no-update-rc
    fi
}

function install_k {
    if [ -d ~/.config/ezsh/oh-my-zsh/custom/plugins/k ]; then
        cd ~/.config/ezsh/oh-my-zsh/custom/plugins/k && git pull
    else
        git clone --depth 1 https://github.com/supercrabtree/k ~/.config/ezsh/oh-my-zsh/custom/plugins/k
    fi
}

function install_fzf_tab {
    if [ -d ~/.config/ezsh/oh-my-zsh/custom/plugins/fzf-tab ]; then
        cd ~/.config/ezsh/oh-my-zsh/custom/plugins/fzf-tab && git pull
    else
        git clone --depth 1 https://github.com/Aloxaf/fzf-tab ~/.config/ezsh/oh-my-zsh/custom/plugins/fzf-tab
    fi
}

function install_marker {
    if [ -d ~/.config/ezsh/marker ]; then
        cd ~/.config/ezsh/marker && git pull
    else
        git clone --depth 1 https://github.com/jotyGill/marker ~/.config/ezsh/marker
    fi

    if ~/.config/ezsh/marker/install.py; then
        echo -e "Installed Marker\n"
    else
        echo -e "Marker Installation Had Issues\n"
    fi
}

function install_todo {
    if [ ! -L ~/.config/ezsh/todo/bin/todo.sh ]; then
        echo -e "${YELLOW}Installing todo.sh in ~/.config/ezsh/todo\n${NC}"
        mkdir -p ~/.config/ezsh/bin
        mkdir -p ~/.config/ezsh/todo
        wget -q --show-progress "https://github.com/todotxt/todo.txt-cli/releases/download/v2.12.0/todo.txt_cli-2.12.0.tar.gz" -P ~/.config/ezsh/
        tar xvf ~/.config/ezsh/todo.txt_cli-2.12.0.tar.gz -C ~/.config/ezsh/todo --strip 1 && rm ~/.config/ezsh/todo.txt_cli-2.12.0.tar.gz
        ln -s -f ~/.config/ezsh/todo/todo.sh ~/.config/ezsh/bin/todo.sh     # so only .../bin is included in $PATH
        ln -s -f ~/.config/ezsh/todo/todo.cfg ~/.todo.cfg     # it expects it there or ~/todo.cfg or ~/.todo/config
    else
        echo -e "${GREEN}todo.sh is already instlled in ~/.config/ezsh/todo/bin/\n${NC}"
    fi
}

function cp_history {
    if [ "$cp_hist_flag" = true ]; then
        echo -e "${YELLOW}\nCopying bash_history to zsh_history\n${NC}"
        if command -v python &>/dev/null; then
            wget -q --show-progress https://gist.githubusercontent.com/muendelezaji/c14722ab66b505a49861b8a74e52b274/raw/49f0fb7f661bdf794742257f58950d209dd6cb62/bash-to-zsh-hist.py
            cat ~/.bash_history | python bash-to-zsh-hist.py >> ~/.zsh_history
        else
            if command -v python3 &>/dev/null; then
                wget -q --show-progress https://gist.githubusercontent.com/muendelezaji/c14722ab66b505a49861b8a74e52b274/raw/49f0fb7f661bdf794742257f58950d209dd6cb62/bash-to-zsh-hist.py
                cat ~/.bash_history | python3 bash-to-zsh-hist.py >> ~/.zsh_history
            else
                echo "${RED}Python is not installed, can't copy bash_history to zsh_history\n${NC}"
            fi
        fi
    else
        echo -e "${RED}\nNot copying bash_history to zsh_history, as --cp-hist or -c is not supplied\n${NC}"
    fi
}

function set_default {
    if [ "$noninteractive_flag" = true ]; then
        echo -e "${GREEN}Installation complete, exit terminal and enter a new zsh session\n"
        echo -e "Make sure to change zsh to default shell by running: chsh -s $(which zsh)"
        echo -e "In a new zsh session manually run: build-fzf-tab-module${NC}"
    else
        echo -e "${YELLOW}\nSudo access is needed to change default shell\n${NC}"
        if chsh -s $(which zsh) && /bin/zsh -i -c 'omz update'; then
            echo -e "${GREEN}Installation complete, exit terminal and enter a new zsh session"
            echo -e "In a new zsh session manually run: build-fzf-tab-module${NC}"
        else
            echo -e "${RED}Something is wrong${NC}"

        fi
    fi
}

function main {
    install_dependencies
    backup_old_configs
    ezsh_dir_structure
    instal_omz
    setup_zcompdump
    install_omz_plugins
    install_fonts
    install_p10k
    install_fzf
    install_k
    install_fzf_tab
    install_marker
    install_todo
    cp_history
    set_default
}

main
