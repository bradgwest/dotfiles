#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
    echo 'Usage: ./install.sh

Install configuration tooling

'
    exit
fi

command-exists() {
  if command -v $1 >/dev/null 2>&1; then
    return 0
  else
    return 1
  fi
}

install_pkgx() {
    if command-exists pkgx; then
        echo "pkgx already installed"
    else
        echo "installing pkgx"
        curl -fsS https://pkgx.sh | sh
    fi
}

install_tmux() {
    if command-exists tmux; then
        echo "tmux already installed"
    else
        echo "installing tmux"
        sudo apt -y install tmux
    fi
}

install_tpm() {
    if [ -d "$HOME/.tmux/plugins/tpm" ]; then
        echo "tpm already installed"
    else
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi
}

install_curl() {
     if command-exists curl; then
        echo "curl already installed"
    else
        echo "installing curl"
        sudo apt -y install curl
    fi
}

install_oh-my-zsh() {
    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo "oh-my-zsh already installed"
    else
        sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi
}

install_starship() {
    if command-exists starship; then
        echo "starship already installed"
    else
        echo "installing starship"
        curl -sS https://starship.rs/install.sh | sh
    fi
}

install_diff-so-fancy() {
    if command-exists diff-so-fancy; then
        echo "diff-so-fancy already installed"
    else
        echo "installing diff-so-fancy"
        git clone git@github.com:so-fancy/diff-so-fancy.git "$HOME/src/diff-so-fancy"
        sudo mv $HOME/src/diff-so-fancy/diff-so-fancy /usr/local/bin
    fi
}

install_fzf() {
    if [ -d "$HOME/.fzf" ]; then
        echo "fzf already installed"
    else
        echo "installing fzf"
        git clone --depth 1 git@github.com:junegunn/fzf.git ~/.fzf
        ~/.fzf/install
    fi
}

install_zsh-autosuggestions() {
    if [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
        echo "zsh-autosuggestions already installed"
    else
        git clone https://github.com/zsh-users/zsh-autosuggestions \
            ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    fi
}

install_auto-notify() {
    if [ -d "$HOME/.oh-my-zsh/custom/plugins/auto-notify" ]; then
        echo "auto-notify already installed"
    else
        git clone https://github.com/MichaelAquilina/zsh-auto-notify.git \
            ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/auto-notify

    fi
}

install_source-code-pro() {
    if [ -f "$HOME/.local/share/fonts/SourceCodePro-Regular.ttf" ]; then
        echo "source-code-pro already installed"
    else
        mkdir -p $HOME/.local/share/fonts
        git clone git@github.com:adobe-fonts/source-code-pro.git $HOME/src/source-code-pro
        cp $HOME/src/source-code-pro/TTF/*.ttf $HOME/.local/share/fonts/
    fi
}

sudo apt update -y

# install tooling
install_curl
install_tmux
install_tpm
install_pkgx
install_starship
install_diff-so-fancy
install_fzf
install_source-code-pro

# oh-my-zsh needs to be last
install_oh-my-zsh
install_zsh-autosuggestions
install_auto-notify

