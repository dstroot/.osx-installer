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
# NAME:           after_dropbox_sync.sh
# PURPOSE:        Restore from Mackup and link Desktop
# VERSION:  1.0   Initial version
# ------------------------------------------------------------------------------
progname=$0
ver="1.0"

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

# identify yourself
cecho "Running: $progname, version $ver." $red

echo ""
cecho "===================================================" $white
cecho " Move ~/Desktop to ~/Dropbox/Desktop? (y/n)" $blue
cecho "===================================================" $white
read -r response
case $response in
  [yY])
  echo ""

  # if ~/Dropbox/Desktop doesn't exist create it
  if [ ! -d ~/Dropbox/Desktop ]; then
    cp -r ~/Desktop ~/Dropbox/Desktop
  fi

  # if ~/Desktop is not linked then link it
  if [ ! -L ~/Desktop ]; then
    # ln -s /path/to/original/folder /path/to/link
    chmod -R -N ~/Desktop
    rm -rf ~/Desktop
    ln -s ~/Dropbox/Desktop ~/Desktop
  fi

esac

echo ""
cecho "===================================================" $white
cecho " Run 'mackup restore'? (y/n)" $blue
cecho "===================================================" $white
read -r response
case $response in
  [yY])
  echo ""

  mackup restore

esac

echo ""
cecho "===================================================" $white
cecho " All Done!" $blue
cecho "===================================================" $white
echo ""

exit 0
