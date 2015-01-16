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
apps=(
  ack               # Search utility
  git               # Newer version than bundled OSX
  go                # Go language
  heroku-toolbelt   # Heroku utilities
  mackup            # Backup utility
  rbenv             # Ruby version manager
  ruby-build        # Build rubies!
  shellcheck        # Great utility to lint shell scripts!
  tree              # tree view of folder
  'wget --with-iri' # Get stuff!
  zsh               # Newer version than bundled OSX
)

# ------------------------------------------------------------------------------
#                 Other apps we *may* want install
# ------------------------------------------------------------------------------
# coreutils         # Install GNU core utilities (those that come with OS X are outdated)
# findutils         # Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
# httpie            # HTTPie: a CLI, cURL-like tool for humans https://github.com/jakubroztocil/httpie
# mongodb           # Mongodb database
# ssh-copy-id       # install your public key in a remote machine's authorized_keys
# rename            # renames files
# tuntap
# python
# openconnect
# rbenv-gemset
# rbenv-gem-rehash
# gsl
# libyaml
# docker
# namebench         # DNS performance utility
# optipng           # compress .png files
# 'imagemagick --with-webp'


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
cecho " 🍺  4) Save a list of installed homebrew packages" $blue
cecho "===================================================" $white
echo ""

now=$(date +"%m_%d_%Y")
filename="${now}_homebrew_packages.txt"

cecho "Saving List of homebrew installed packages" $white
brew leaves > $HOME/.osx-installer/whats-installed/$filename

echo ""
cecho "===================================================" $white
cecho " 🍺  5) All Done!" $blue
cecho "===================================================" $white
echo ""
