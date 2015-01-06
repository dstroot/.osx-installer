#! /bin/sh
# # ------------------------------------------------------------------------------
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
# This script is designed to be idempotent
# ------------------------------------------------------------------------------
# NAME:           brew.sh
# PURPOSE:        Install homebrew, keep homebrew current, and install
#                 all homebrew and cask apps
# VERSION:  1.0   Initial version.
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

echo ""
cecho "===================================================" $white
cecho " 🍺  1) Installing/updating homebrew" $blue
cecho "===================================================" $white
echo ""

# See if homebrew is installed, if not install it
if test ! $(which brew)
  then
    cecho 'Installing Homebrew...' $blue
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    cecho "Homebrew is installed: $(brew -v)" $white
  else
    cecho "Homebrew is installed: $(brew -v)" $white
fi

# Make sure everything is tip top
if test $(which brew)
  then
    # Make sure we’re setup properly
    brew doctor
    # Make sure we’re using the latest Homebrew
    brew update
    # Upgrade any already-installed formulae
    brew upgrade
fi

echo ""
cecho "===================================================" $white
cecho " 🍺  2) Install homebrew apps" $blue
cecho "===================================================" $white

# --------------------------------------------------------
# NOTE: maintain this array to manage your list of apps!
#       To see what is currently installed: `brew leaves`
# --------------------------------------------------------
apps=(
  ack               # Search utility
  'wget --with-iri' # Get stuff!
  git               # Newer version than bundled OSX
  zsh               # Newer version than bundled OSX
  tree              # tree view of folder
  # python            # Needed for Mackup?
  mackup            # Backup utility
  rbenv             # Ruby version manager
  ruby-build        # Build rubies!
  shellcheck        # Great utility to lint shell scripts!
  go                # Go language
  # heroku-toolbelt   # Heroku utilities
)

# --------------------------------------------------------
# Other apps we *may* want install
# --------------------------------------------------------
# coreutils         # Install GNU core utilities (those that come with OS X are outdated)
# findutils         # Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
# httpie            # HTTPie: a CLI, cURL-like tool for humans https://github.com/jakubroztocil/httpie
# mongodb           # Mongodb database
# ssh-copy-id       # install your public key in a remote machine's authorized_keys
# spark             # Command line sparklines
# rename            # renames files
# tuntap
# openconnect
# rbenv-gemset
# rbenv-gem-rehash
# gsl
# libyaml
# docker
# namebench         # DNS performance utility
# optipng           # compress .png files
# 'imagemagick --with-webp'

# Install homebrew apps
echo ""
cecho "Installing homebrew apps" $blue
for i in "${apps[@]}"
do
  echo ""
  cecho "installing: $i" $green
  brew install $i
done

echo ""
cecho "===================================================" $white
cecho " 🍺  3) Cleanup homebrew" $blue
cecho "===================================================" $white
echo ""

if test $(which brew)
  then

    # For all installed formulae, remove any older versions from the cellar.
    brew cleanup --force

    # Remove dead symlinks from the Homebrew prefix. This is generally not needed.
    #brew prune

    # Find installed formulae that have compiled .app-style "application"
    # packages  for  OSX,  and symlink those apps into /Applications,
    # allowing for easier access.
    #brew linkapps
fi

echo ""
cecho "===================================================" $white
cecho " 🍺  4) Installing brew cask and apps" $blue
cecho "===================================================" $white

echo ""
cecho "Installing cask" $blue
brew tap caskroom/versions
brew install caskroom/cask/brew-cask

# Make sure we’re using the latest Brew/Cask
brew cask update

# --------------------------------------------------------
# NOTE: maintain this array to manage your list of apps!
#       To see what is currently installed: `brew cask list`
# --------------------------------------------------------

# NOTE: you can install both Chrome and Lastpass with
#       homebrew cask.  However I feel safer downloading
#       and installing directly.

casks=(
  # google-chrome           # See note
  # lastpass                # See note
  logitech-unifying
  iterm2
  flux                    # Screen lighting
  spectacle               # Window mgmt utility
  skype
  dropbox
  filezilla
  cheatsheet
  sublime-text
  atom
  macdown
  sonos
  spotify
  vagrant
  virtualbox
)

# --------------------------------------------------------
# Apps we *may* want install
# --------------------------------------------------------
# github                 # already installed (to clone this repo)
# slack
# teamviewer
# air-video-server-hd
# airserver
# airdisplay
# airmail-beta
# alfred
# appcleaner
# authy-bluetooth
# beamer
# cakebrew
# chromecast
# cinch
# daisydisk
# gifrocket
# istat-menus
# licecap
# liteitcon
# mailbox
# onepassword
# pixlr
# recordit
# transmission
# vlc

# ## Coding
# ## ---------------------------------
# sourcetree
# the-unarchiver

# # Keyboard Editor
# ukelele
# ## Image Tools
# imagealpha
# imageoptim
# miro-video-converter

# ## QuickLook plugins
# ## ---------------------------------
# qlcolorcode
# qlstephen
# qlmarkdown
# quicklook-json
# betterzipql
# suspicious-package
# # PDF reader
# skim
# # Picture viewer
# xee22
# # Soundcloud client (yes, that's the correct spelling)
# soundcleod
# # Adobe Flash
# flash
# # Podcast player
# instacast
# # Bittorrent client
# transmission
# ## Work
# # Screen recording
# screenflow
# screenflick
# ## Notes
# ## --------------------------------
# nvalt     # http://www.macupdate.com/app/mac/36277/nvalt
# # VMware View
# vmware-horizon-view-client
# # Collaboration
# slack
# # Compression
# keka



# Install cask apps
echo ""
cecho "Installing cask apps" $blue
for i in "${casks[@]}"
do
  echo ""
  cecho "installing: $i" $green
  # brew cask install --appdir="/Applications" $i
  brew cask install $i
done

echo ""
cecho "Cleaning up" $blue
brew cask cleanup

echo ""
cecho "===================================================" $white
cecho " 🍺  5) Installing fonts" $blue
cecho "===================================================" $white

echo ""
cecho "Tapping caskroom/fonts" $blue
brew tap caskroom/fonts

fonts=(
  # font-droid-sans
  font-droid-sans-mono           # Good programming font
  # font-open-sans
  # font-open-sans-condensed
  # font-roboto
  # font-m-plus
  font-source-code-pro           # Main programming font
)

# Install fonts
echo ""
cecho "Installing fonts" $blue
for i in "${fonts[@]}"
do
  echo ""
  cecho "installing: $i" $green
  brew cask install $i
done

echo ""
cecho "Cleaning up" $blue
brew cask cleanup

echo ""
cecho "===================================================" $white
cecho " 🍺  6) Save a list of installed brew packages" $blue
cecho "===================================================" $white
echo ""

now=$(date +"%m_%d_%Y")

cecho "Saving List of homebrew installed packages" $white
brew leaves > ~/.dotfiles/homebrew/brew_packages_$now.txt

cecho "Saving List of homebrew *cask* installed packages" $white
brew cask list > ~/.dotfiles/homebrew/brew_cask_packages_$now.txt

echo ""
cecho "===================================================" $white
cecho " 🍺  All Done!" $blue
cecho "===================================================" $white
echo ""

exit 0
