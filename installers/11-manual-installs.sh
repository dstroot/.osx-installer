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

cecho " Some apps are not found in the App Store and" $white
cecho " are not available in Homebrew either. I can open" $white
cecho " their websites for you to install them. Should I" $white
cecho " open them? (Y/n)" $white
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
