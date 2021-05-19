# color time according to last return code
PROMPT="%{$fg[blue]%}%*%{$reset_color%} "
PROMPT+='$(virtualenv_prompt_info)'
# cwd
PROMPT+='%{$fg_bold[cyan]%}%~%{$reset_color%} '
PROMPT+='$(git_prompt_info)'
# color prompt according to last return code
PROMPT+="%(?:%{$fg_bold[green]%}$ :%{$fg_bold[red]%}$ )%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[blue]%}(%{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%})"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

# Need virtualenv enabled
ZSH_THEME_VIRTUALENV_PREFIX="("
ZSH_THEME_VIRTUALENV_SUFFIX=") "

