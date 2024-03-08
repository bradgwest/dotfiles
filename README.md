# dotfiles

## Getting Started

**Prerequisites**
* git (and ssh key added to [account](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account))
* [GNU Stow](https://www.gnu.org/software/stow/)

```sh
git clone git@github.com:bradgwest/dotfiles.git
cd dotfiles

git checkout wsl2-ubuntu-22.04

./install.sh

stow
```


## Docs

See [Using Stow to Manage Dotfiles](https://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html)
for how this works.
