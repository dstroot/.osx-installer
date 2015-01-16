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
# NAME:           set_autofs.sh
# PURPOSE:        setup autofs shares
# VERSION:  1.0   Initial version
# ------------------------------------------------------------------------------
root="$HOME/.osx-installer/osx-files/"

# File array
FILES=(
auto_master
auto_resources
)

# file functions
move_files () {
  sudo mv $1 $1\.backup
  cecho "moved $1 to $1.backup" $yellow
}

# ln -s /path/to/original/folder /path/to/link
link_files () {
  sudo ln -sf $1 $2
  cecho "linked $1 to $2" $green
}

copy_files () {
  sudo cp -f $1 $2
  cecho "copied $1 to $2" $green
}

# Process files
for i in "${FILES[@]}"
do
  DEST="/etc/$i"
  SOURCE="$root$i"

  if [[ -f $DEST ]]; then
    # backup files
    move_files $DEST
  fi

  # Link to dotfiles versions
  copy_files $SOURCE $DEST

  if [ $i == "auto_resources" ]
  then
    sudo chmod 600 $DEST
  fi

done

# Run Automount
sudo automount -vc
