#!/bin/sh

MAC_SETUP_DIR="$HOME/mac-setup"
source $MAC_SETUP_DIR/lib/print.sh

# Ask for the administrator password upfront
sudo -v

# Generate an SSH key if one does not already exist
if [ ! -f "$HOME/.ssh/id_ed25519.pub" ]; then
  step "Generating SSH key"
  ssh-keygen -t ed25519 -f "$HOME/.ssh/id_ed25519"
  echo "Copy and paste the public portion of the key (below) to GitHub"
  echo "============ Public key ============="
  cat ~/.ssh/id_ed25519.pub
  echo "====================================="
  . read -r -p "Press any key to continue... " -n 1
fi

# Add the SSH key to the agent now to avoid multiple prompts
if ! ssh-add -L -q > /dev/null ; then
  ssh-add
fi

# Install Homebrew
step "Installing Homebrew"
if ! type brew > /dev/null; then
  /usr/bin/ruby -e \
    "$(curl \
      -fsSL \
      https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Install zsh
step "Installing zsh"
brew install zsh

# Change the shell
step "Changing shell to zsh"
"$MAC_SETUP_DIR/lib/shell.sh"

# Install oh-my-zsh
step "Installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

step "Setting hostnames"
printf "Insert hostname (ENTER to skip): "
read hostname
if [[ -z "$hostname" ]]; then
  echo "skipping..."
else
  echo "Setting hostname to '$hostname'"
  if [[ $(scutil --get HostName) != "$hostname" ]]; then
    scutil --set HostName "$hostname"
  fi

  if [[ $(scutil --get LocalHostName) != "$hostname" ]]; then
    scutil --set LocalHostName "$hostname"
  fi

  if [[ $(scutil --get ComputerName) != "$hostname" ]]; then
    scutil --set ComputerName "$hostname"
  fi
fi

# Install iterm2
step "Installing iterm2"
brew cask install "iterm2"

finish

if [[ $TERM_PROGRAM != "iTerm.app" ]]; then
  open -a iTerm; killall Terminal
fi