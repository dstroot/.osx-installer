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
# NAME:           pip.sh
# PURPOSE:        Install and maintain python modules
# VERSION:  1.0   Initial version.
# DESCRIPTION:    Why use Pip over easy_install?
#
# 1) All packages are downloaded before installation. Partially-completed
#    installation doesn’t occur as a result.
#
# 2) The reasons for actions are kept track of. For instance, if a package
#    is being installed, pip keeps track of why that package was required.
#
# 3) The code is relatively concise and cohesive, making it easier to use
#    programmatically.
#
# 4) Packages don’t have to be installed as egg archives, they can be
#    installed flat.
#
# 5) Native support for other version control systems (Git, Mercurial)
#
# 6) Uninstallation of packages.
#
# 7) Simple to define fixed sets of requirements and reliably reproduce a
#    set of packages.
# ------------------------------------------------------------------------------

echo ""
cecho "===================================================" $white
cecho " Install pip" $blue
cecho "===================================================" $white
echo ""

if test ! $(which pip)
  then
    cecho "Installing pip" $white
    sudo easy_install pip
  else
    cecho "$(python --version)Pip installed: $(pip -V | awk '{ print $2 }')" $white
fi

echo ""
cecho "===================================================" $white
cecho " Install/update python packages" $blue
cecho "===================================================" $white
echo ""

pip_modules=(
  # pygments
  # speedtest-cli
  # virtualenv
  # virtualenvwrapper
  # flake8
)

for i in "${pip_modules[@]}"
do
  cecho "Installing: $i" $green
  pip install $i
done


echo ""
cecho "===================================================" $white
cecho " Save a list of pip packages" $blue
cecho "===================================================" $white
echo ""

if test $(which pip)
  then
    now=$(date +"%m_%d_%Y")
    cecho "Saving List of pip packages" $white
    pip list > ~/.osx-installer/whats-installed/installed_pips_$now.txt
fi

echo ""
cecho "===================================================" $white
cecho " All Done!" $blue
cecho "===================================================" $white
echo ""

exit 0
