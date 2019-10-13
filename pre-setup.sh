#!/bin/sh

MAC_SETUP_DIR="$HOME/mac-setup"

BOLD="\033[1m"
WHITE="\033[0;37m"
YELLOW="\033[1;33m"
GREEN="\033[1;32m"
NC="\033[0m"

step() {
  echo
  echo "${YELLOW}❯❯❯ ${WHITE}${BOLD}$1${NC} ${YELLOW}❮❮❮${NC}"
}

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

# Install oh-my-zsh
step "Installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

step "Setting hostnames to 'w'"
if [[ $(scutil --get HostName) != "w" ]]; then
  scutil --get HostName "w"
fi

if [[ $(scutil --get LocalHostName) != "w" ]]; then
  scutil --get LocalHostName "w"
fi

if [[ $(scutil --get ComputerName) != "w" ]]; then
  scutil --set ComputerName "w"
fi

# Install iterm2
step "Installing iterm2"
brew cask install "iterm2"

echo "${GREEN}✔ ${WHITE}${BOLD}Done!${NC} 🎉"