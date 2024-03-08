for file in ~/.{path,secrets,exports,aliases,functions,extra}; do
  if [[ -r "$file" ]] && [[ -f "$file" ]]; then
    source "$file"
  fi
done
unset file

plugins=(
  git
  colored-man-pages
  fzf
  zsh-autosuggestions
  tmux
  virtualenv
  vi-mode
)

source $HOME/.oh-my-zsh/oh-my-zsh.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# needs to be here, and not in .exports
export GPG_TTY=$(tty)

# use vim mode for zle
bindkey -v
# support ^e
bindkey '^f' vi-forward-char

# starship start up
eval "$(starship init zsh)"

source <(pkgx --shellcode)  #docs.pkgx.sh/shellcode

hash -d src=$HOME/src

