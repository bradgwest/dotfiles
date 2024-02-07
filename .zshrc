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

# ZSH_THEME="dubs"

plugins=(
  git
  colored-man-pages
  fzf
  zsh-autosuggestions
  tmux
  auto-notify
  virtualenv
  vi-mode
)

source $HOME/.oh-my-zsh/oh-my-zsh.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# needs to be here, and not in .exports
export GPG_TTY=$(tty)

# start asdf - use pkgx for most stuff, asdf as backup
# . $HOME/.asdf/asdf.sh
# asdf completions
# # fpath=(${ASDF_DIR}/completions $fpath)
# # initialise completions with ZSH's compinit
# autoload -Uz compinit && compinit

# use vim mode for zle
bindkey -v
# support ^e
bindkey '^f' vi-forward-char

# starship start up
eval "$(starship init zsh)"

source <(pkgx --shellcode)  #docs.pkgx.sh/shellcode

hash -d jn=$HOME/src/job-notifier
hash -d swe=$HOME/src/swepay
hash -d resume=$HOME/src/resume
