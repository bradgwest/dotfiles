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
  aws
  git
  kubectl
  colored-man-pages
  fzf
  zsh-autosuggestions
  # using startship.rs to push desktop notifications
  # auto-notify
  terraform
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

# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)
# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit

# forge (internal infrastructure management tool) autocompletions
source ~/src/forge/forge_completion.zsh

# starship start up
eval "$(starship init zsh)"

hash -d mt=$HOME/src/dbt-cloud-infra-terraform
hash -d st=$HOME/src/dbt-cloud-infra-single-tenant
hash -d hv=$HOME/src/dbt-cloud-helm-values
hash -d api=$HOME/src/dbt-cloud-api-gateway
hash -d tfm=$HOME/src/dbt-cloud-infra-terraform-modules
hash -d tfaws=$HOME/src/terraform-aws-dbt-cloud-single-tenant-internal
hash -d tfaz=$HOME/src/terraform-azurerm-dbt-cloud-single-tenant
hash -d tfddog=$HOME/src/terraform-datadog
hash -d hc=$HOME/src/helm-charts
hash -d hr=$HOME/src/helm-releases
hash -d dt=$HOME/src/dev-tools
hash -d it=$HOME/src/infra-tools
hash -d forge=$HOME/src/forge
hash -d adc=$HOME/src/argo-deployment-configs
hash -d ia=$HOME/src/internal-actions
hash -d cloud=$HOME/src/dbt-cloud
hash -d stdocs=$HOME/src/dbt-cloud-single-tenant-docs
hash -d ii=$HOME/src/internal-images
hash -d rw=$HOME/src/reverse-words

source /Users/bw/.docker/init-zsh.sh || true # Added by Docker Desktop

source <(pkgx --shellcode)  #docs.pkgx.sh/shellcode
