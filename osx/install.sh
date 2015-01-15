#! /bin/sh
# ------------------------------------------------------------------------------
# Copyright (c) 2014 Dan Stroot
# All rights reserved.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
# IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
# ------------------------------------------------------------------------------
# NAME:           install.sh
# PURPOSE:        Installs 'all the things'
# VERSION:  1.0   Initial version
# ------------------------------------------------------------------------------
# What it does:
# ------------------------------------------------------------------------------
#  1. Prompts you to install Apple App Store Apps (should be done already)
#  2. Installs .oh-my-zsh
#  3. Installs Homebrew/Stuff (must be ahead of Ruby because it installs rbenv)
#  4. Installs Node/NPM and NPM global modules
#  5. Installs Ruby/Ruby Gems (managed by rbenv)
#  6. Installs Python (PIP) Stuff
#  7. Installs Google Fonts
#  8. Installs Go
#  9. Sets up Autofs (fileshares)
# 10. Prompts you to manually install apps
# 11. Prompts you to setup Microsoft Office
# 12. Applies OSX defaults
# ------------------------------------------------------------------------------
# References & Resources:
#  - https://github.com/MatthewMueller/dots
#  - https://github.com/thoughtbot/laptop
# ------------------------------------------------------------------------------
ver="1.0"
progname=$0

# Define colors
black='\033[0;30m'
white='\033[0;37m'
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
magenta='\033[0;35m'
cyan='\033[0;36m'

#  Reset text attributes to normal
alias Reset="tput sgr0"

# Color-echo.
#   Argument $1 = message
#   Argument $2 = Color

cecho() {
  echo "${2}${1}"
  Reset # Reset to normal.
  return
}

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo ""
cecho "===================================================" $white
cecho " 1) Apple App Store apps" $blue
cecho "===================================================" $white

# Any way to automate these?
echo ''
echo 'One of the first things you should do is sign into the App Store and'
echo 'download and install your applications. You should have *already* '
echo 'done this since you must have Xcode installed before you proceed.'
echo ''
cecho 'Should I open the App Store for you? (y/N)' $green
read -r response
case $response in
  [yY])
  open -a "app store"
esac

# NOTE: Below no longer needed because when you use git for the first
# time on Yosemite it prompts for the command line tools to be installed.

# echo ""
# cecho "===================================================" $white
# cecho " 2) Install the XCode Command-line Tools? (y/n)" $blue
# cecho "===================================================" $white
# read -r response
# case $response in
#   [yY])
#   echo ""
#   echo "Installing the Xcode Command-line tools"
#   xcode-select --install
# esac

echo ""
cecho "===================================================" $white
cecho " 2) Install oh-my-zsh? (y/n)" $blue
cecho "===================================================" $white
read -r response
case $response in
  [yY])
  echo ""

  curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh

  # install zsh syntax highlighting
  cd ~/.oh-my-zsh/custom/plugins
  git clone git://github.com/zsh-users/zsh-syntax-highlighting.git

esac

echo ""
cecho "===================================================" $white
cecho " 3) 🍺 Install homebrew? (y/n)" $blue
cecho "===================================================" $white
read -r response
case $response in
  [yY])
  sh "$HOME"/.dotfiles/homebrew/brew.sh
esac

echo ""
cecho "===================================================" $white
cecho " 4) Install Node/npm? (y/n)" $blue
cecho "===================================================" $white
read -r response
case $response in
  [yY])
  sh "$HOME"/.dotfiles/npm/npm.sh

  # create link for pure prompt
  ln -s ~/.npm-global/lib/node_modules/pure-prompt/pure.zsh ~/.oh-my-zsh/custom/pure.zsh-theme
esac

echo ""
cecho "===================================================" $white
cecho " 5) Install Ruby & Gems (packages)? (y/n)" $blue
cecho "===================================================" $white
read -r response
case $response in
  [yY])
  sh "$HOME"/.dotfiles/ruby/gems.sh
esac

echo ""
cecho "===================================================" $white
cecho " 6) Install pip and python packages? (y/n)" $blue
cecho "===================================================" $white
read -r response
case $response in
  [yY])
  sh "$HOME"/.dotfiles/pip/pip.sh
esac

echo ""
cecho "===================================================" $white
cecho " 7) Install Google Fonts? (y/n)" $blue
cecho "===================================================" $white
read -r response
case $response in
  [yY])
  sh "$HOME"/.dotfiles/osx/google_fonts.sh
esac

echo ""
cecho "===================================================" $white
cecho " 8) Setup Go? (y/n)" $blue
cecho "===================================================" $white
read -r response
case $response in
  [yY])

  # Note: Go will already be installed by homebrew by
  #       this point.

  # Create directories
  mkdir $HOME/Go
  mkdir -p $GOPATH/src/github.com/user

  # Setup your exports and paths:
  export GOPATH=$HOME/Go
  export GOROOT=/usr/local/opt/go/libexec
  export PATH=$PATH:$GOPATH/bin
  export PATH=$PATH:$GOROOT/bin

  # `go get` the basics:
  go get code.google.com/p/go.tools/cmd/godoc
  go get code.google.com/p/go.tools/cmd/vet

esac

echo ""
cecho "===================================================" $white
cecho " 9) Setup Autofs (Network Shares)? (y/n)" $blue
cecho "===================================================" $white
read -r response
case $response in
  [yY])
  sh ~/.dotfiles/osx/autofs.sh
esac

echo ""
cecho "===================================================" $white
cecho " 10) Some apps are not found in the App Store and" $blue
cecho " are not available in Homebrew either. I can open" $blue
cecho " their websites for you to install them. Should I" $blue
cecho " open them? (y/n)" $blue
cecho "===================================================" $white
read -r response
case $response in
  [yY])

  # NOTE: you can install both Chrome and Lastpass with
  #       homebrew cask.  However I feel safer knowing I
  #       am downloading and installing directly.

  echo 'Install apps:'
  echo ''
  echo '1) Chrome'
  open http://www.google.com/chrome/
  echo '2) Lastpass'
  open https://lastpass.com/
  # echo '2) Dropbox'
  # open http://www.dropbox.com/
  # echo '3) Cheatsheet'
  # open http://www.grandtotal.biz/CheatSheet/
  # echo '4) Fitbit'
  # open http://www.fitbit.com/setup?platform=mac
  # echo '4) VirtualBox'
  # open https://www.virtualbox.org/
  # echo '5) Vagrant'
  # open http://www.vagrantup.com/
  # echo '6) soundflower'
  # open https://code.google.com/p/soundflower/
  # echo '7) Skype'
  # open http://www.skype.com/en/
  # echo '8) iterm2'
  # open http://www.iterm2.com/
  # echo '9) Spectacle'
  # open http://spectacleapp.com/
esac

echo ""
cecho "===================================================" $white
cecho " 11) Install Microsoft Office? (y/n)" $blue
cecho "===================================================" $white
read -r response
case $response in
  [yY])
  open -a "textedit" "$HOME/Software/ISOs/Microsoft Office Family/Office Mac 2011/product key.txt"
  hdiutil attach "$HOME/Software/ISOs/Microsoft Office Family/Office Mac 2011/Microsoft Office 2011.dmg"
esac

echo ""
cecho "===================================================" $white
cecho " 12) Set OSX defaults? (y/n)" $blue
cecho "===================================================" $white
read -r response
case $response in
  [yY])

  cecho "Final manual steps: (YOU must remember this!!!)" $white
  cecho " [ ] Sign into dropbox and let it fully sync." $yellow
  cecho " [ ] Run '~/.dotfiles/after_dropbox_sync.sh'" $yellow

  read -p "Press [Enter] key to continue..."

  # Install my osx defaults
  cd ~
  git clone https://github.com/dstroot/.osx

  # Set OS X defaults (do it last because it kills everything!!!)
  sh ~/.osx/osx_defaults.sh

esac

exit 0
