for file in ~/.{path,secrets,exports,aliases,functions,extra}; do
  if [[ -r "$file" ]] && [[ -f "$file" ]]; then
    source "$file"
  fi
done
unset file

# Setup homebrew env
eval "$(/opt/homebrew/bin/brew shellenv)"

# Set Homebrew autocompletions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

  autoload -Uz compinit
  compinit
fi

ZSH_THEME="dubs"

plugins=(
  git
  kubectl
  colored-man-pages
  fzf
  zsh-autosuggestions
  auto-notify
  tmux
  virtualenv
  vi-mode
)

source $HOME/.oh-my-zsh/oh-my-zsh.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# needs to be here, and not in .exports
# export GPG_TTY=$(tty)

# start asdf
. $HOME/.asdf/asdf.sh

# use vim mode for zle
bindkey -v
# support ^e
bindkey '^f' vi-forward-char

