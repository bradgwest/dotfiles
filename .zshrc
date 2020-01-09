setopt autocd
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/dubs/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Load env vars and others
for file in ~/.{aliases,functions,path,dockerfunc,extra,exports}; do
  if [[ -r "$file" ]] && [[ -f "$file" ]]; then
    source "$file"
  fi
done
unset file

# Start i3
if systemctl -q is-active graphical.target && [[ ! DISPLAY && XDG_VTNR -eq 1 ]]; then
  exec /bin/startx
fi

