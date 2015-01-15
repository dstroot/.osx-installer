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

# ------------------------------------------------------------------------------
# NOTE: Maintain this array to manage your list of apps!
#       To see what is currently installed: `brew leaves`
# ------------------------------------------------------------------------------

# NOTE: You can install both Chrome and Lastpass with homebrew cask.
#       However I feel safer downloading and installing directly.

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

# ------------------------------------------------------------------------------
#                 Other apps we *may* want install
# ------------------------------------------------------------------------------

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


######
# MEDIA
######

# transmission  # Bitorrent client
# vlc
# slack
# soundcleod  # Soundcloud client (yes, that's the correct spelling)

######
# SOFTWARE DEVELOPMENT
######

# github                 # already installed (to clone this repo)
# sourcetree
# the-unarchiver

# # Keyboard Editor
# ukelele

######
# IMAGING
######

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

# # Adobe Flash
# flash

# # Podcast player
# instacast

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




echo ""
cecho "===================================================" $white
cecho " 🍺  1) Installing brew cask and apps" $blue
cecho "===================================================" $white

echo ""
cecho "Installing cask" $green
brew tap caskroom/versions
brew install caskroom/cask/brew-cask

# Make sure we’re using the latest Brew/Cask
brew cask update

# Install cask apps
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
cecho " 🍺  2) Installing cask fonts" $blue
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
cecho " 🍺  3) Save a list of installed cask packages" $blue
cecho "===================================================" $white
echo ""

now=$(date +"%m_%d_%Y")

cecho "Saving List of homebrew *cask* installed packages" $white
brew cask list > ~/.osx-installer/whats-installed/cask_packages_$now.txt

echo ""
cecho "===================================================" $white
cecho " 🍺  All Done!" $blue
cecho "===================================================" $white
echo ""
