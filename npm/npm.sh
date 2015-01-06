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
# This script is designed to be idempotent
# ------------------------------------------------------------------------------
# NAME:           npm.sh
# PURPOSE:        Install and maintain global npm modules
# VERSION:  1.0   Initial version
# ------------------------------------------------------------------------------
ver="1.0"
progname=$0

# set -e
# set -x   # debugging mode?

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

# echo ""
# cecho "===================================================" $white
# cecho " Remove old Node/NPM first? (y/n)" $blue
# cecho "===================================================" $white
# read -r response
# case $response in
#   [yY])
#   echo ""
#   echo "Removing Node"
#
#   # Homebrew
#   brew uninstall node
#
#   # executable
#   rm -f /usr/local/bin/node
#   sudo rm -rf /usr/local/include/node
#
#   # dtrace
#   sudo rm -f /usr/local/lib/dtrace/node.d
#
#   # man pages
#   rm -f /usr/local/share/man/man1/node.1
#
#   echo "Removing NPM"
#   sudo rm /usr/local/bin/npm
#   sudo rm -rf /usr/local/lib/node_modules
#   rm -f /usr/local/share/man/man1/npm*
# esac

echo ""
cecho "===================================================" $white
cecho " Install Node and NPM" $blue
cecho "===================================================" $white
echo ""

node='v0.10.35'

# Notes: Node and NPM seem to be going their separate ways.
# Node bundles NPM but it is a very old version and Node and NPM
# update at different frequencies.  It's better to keep them separate.

if test ! $(which node)
then

  # --------------------------------------
  # Homebrew method
  # --------------------------------------

  # The view from npm-land is npm is its own package manager
  # and it is therefore better to have npm manage itself and
  # its packages instead of letting Homebrew do it.
  cecho "Installing node (without npm) via homebrew" $blue
  brew install node --without-npm
  cecho "Node is installed: $(node -v)" $white

  cecho "Installing npm" $blue
  curl -L https://www.npmjs.org/install.sh | sh
  cecho "NPM is installed: v$(npm -v)" $white
  cecho "NPM global directory: $(npm config get prefix)"

  # This fixes EACCESS issues when using `npm install -g`
  # since the default path is `/usr/local`
  # *comment out* of using a different location
  # for npm global modules (see below)
  #sudo chown -R `whoami` /usr/local

  # --------------------------------------
  # Native installation method
  # --------------------------------------

  # cecho "Installing Node:" $blue
  # wget http://nodejs.org/dist/$node/node-$node.pkg
  # sudo installer -pkg node-$node.pkg -target /
  # rm node-$node.pkg
  # cecho "Node is installed: $(node -v)" $white
  #
  # # Node comes with npm installed so you should have a
  # # version of npm. However, npm gets updated more frequently
  # # than Node does, so update to the latest version.
  # sudo npm install npm -g
  #
  # # This fixes EACCESS issues when using `npm install -g`
  # # since the default path is `/usr/local`
  # sudo chown -R `whoami` /usr/local
  #
  # cecho "NPM is installed: v$(npm -v)" $white
  # cecho "NPM global directory: $(npm config get prefix)" $white

  # --------------------------------------
  # If you want to change NPM's default global
  # directory then uncomment this section:
  # --------------------------------------

  # Make a directory for global installations:
  mkdir -p ~/.npm-global

  # Configure npm to use the new directory path:
  npm config set prefix '~/.npm-global'
  export PATH=~/.npm-global/bin:$PATH
  npm install npm -g
  cecho "NPM global directory changed: $(npm config get prefix)"

  # Remove old npm
  sudo rm /usr/local/bin/npm
  sudo rm -rf /usr/local/lib/node_modules

else
  cecho "Node is installed: $(node -v)" $white
  cecho "NPM is installed: v$(npm -v)" $white
  cecho "NPM global directory: $(npm config get prefix)"
fi

echo ""
cecho "===================================================" $white
cecho " Installing global npm modules" $blue
cecho "===================================================" $white
echo ""

# --------------------------------------------------------
# NOTE: maintain this array to manage your list of modules!
#       To see what is currently installed: `npm -g ls --depth=0`
# --------------------------------------------------------
npm_modules=(
  bower
  grunt
  grunt-cli
  gulp
  nodemon
  mocha
  jitsu
  n                   # node version manager
  npm-check           # check for updates
  pure-prompt         # great ZSH prompt
  markdown-live       # https://www.npmjs.com/package/markdown-live
#  yo                  # Yeoman
#  generator-angular-fullstack
#  generator-react-webpack
#  strongloop
#  strong-studio
#  react-tools
#  pleeease            # process CSS
)


# --------------------------------------------------------
# Other modules we *may* want install
# --------------------------------------------------------
# istanbul
# a11y                # Accessibility Audit
# azure-cli
# duo                 # https://github.com/duojs/duo
# hicat               # cat with syntax highlighting
# vtop                # graphical top https://www.npmjs.com/package/vtop
# js-beautify         # https://www.npmjs.com/package/js-beautify
# jscs
# jspm
# keybase-installer
# less
# npm-release         # Tiny tool for releasing npm modules.
# peerflix            # Streaming torrent client for Node.js
# resume-cli          # JSON Resume format
# uglify-js           # https://www.npmjs.com/package/uglify-js
# write-good          # Checks your prose https://www.npmjs.com/package/write-good


for i in "${npm_modules[@]}"
do
  if test ! $(which $i)
    then
      cecho "Installing: $i" $green
      npm install -g $i
    else
      cecho "$i is installed" $green
  fi
done

echo ""
cecho "===================================================" $white
cecho "Install latest Node versions" $blue
cecho "===================================================" $white
echo ""

cecho "Installing node stable and latest" $white
n latest
n stable

echo ""
cecho "===================================================" $white
cecho " Updating global NPM modules" $blue
cecho "===================================================" $white
echo ""

# NOTE: *Don't* use `npm update -g`!
# See:  https://docs.npmjs.com/getting-started/updating-global-packages
#       https://github.com/npm/npm/issues/6247

# List outdated packages
npm outdated -g --depth=0
echo ""

for package in $(npm -g outdated --parseable --depth=0 | cut -d: -f2)
do
  cecho "Updating: $package" $green
  npm install "$package" -g
done

echo ""
cecho "===================================================" $white
cecho " Save a list of installed global NPM modules" $blue
cecho "===================================================" $white
echo ""

now=$(date +"%m_%d_%Y")
cecho "Saving List of NPM Global Packages" $white
npm -g ls --depth=0 > ~/.dotfiles/npm/npm_global_packages_$now.txt 2>&1

echo ""
cecho "===================================================" $white
cecho " All Done!" $blue
cecho "===================================================" $white
echo ""

exit 0
