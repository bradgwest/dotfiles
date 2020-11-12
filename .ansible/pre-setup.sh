#!/usr/bin/env bash

# echo "You need xcode command line tools installed. 'y' to open the install dialog; 'n' to skip: (y/n)"
# read $response

# Install Xcode command line tools if needed, otherwise pass
if [ ! -f "`which xcodebuild`" ]; then
    echo "You need xcode command line tools installed. Installing now."
    xcode-select --install
else
    echo "xcode tools already installed. You should probably update them with Software Updates."
fi

# Install Homebrew if needed, otherwise update
if [ ! -f "`which brew`" ]; then
    echo "Installing Homebrew"
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh
else
    echo "Homebrew already installed, updating."
    brew update
fi

# Install ansible if needed
if [ ! -f "`which ansible`" ]; then
    brew install ansible
else
    brew upgrade ansible
fi

# Install firefox
if [ ! -d /Applications/Firefox.app ]; then
    brew cask install firefox
fi

echo "You will need to configure ssh keys before continuing."
echo "Github SSH docs:"
echo "    https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/connecting-to-github-with-ssh"
echo "Authorizing an SSH key for use with SSO:"
echo "    https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/authorizing-an-ssh-key-for-use-with-saml-single-sign-on"
echo "When finished, run the ansible playbook from this repo:"
echo "    ansible-playbook local.yaml"
