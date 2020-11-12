# Start tmux automatically
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi

# Load env vars and others
for file in ~/.{aliases,functions,exports,path,dockerfunc,extra}; do
  if [[ -r "$file" ]] && [[ -f "$file" ]]; then
    source "$file"
  fi
done
unset file

ZSH_THEME="bread"
plugins=(
  auto-notify
  colored-man-pages
  fzf # fzf will enable the fuzzy autocompletions bound to Ctrl-R
  git
  zsh-autosuggestions
)
source $ZSH/oh-my-zsh.sh

# fuzzy searcher needs to be near end of file (after path)
# https://github.com/junegunn/fzf
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
