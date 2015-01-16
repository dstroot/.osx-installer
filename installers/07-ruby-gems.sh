#!/bin/sh
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
# NAME:           gems.sh
# PURPOSE:        Install ruby gems
# VERSION:  1.0   Initial version.
# ------------------------------------------------------------------------------
# References:
#   http://guides.rubygems.org/command-reference/#gem_update
#   https://developer.apple.com/library/mac/#documentation/opensource/conceptual/shellscripting/AdvancedTechniques/AdvancedTechniques.html
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# NOTE: maintain this array to manage your list of gems!
#       To see what is currently installed: `gem list`
# ------------------------------------------------------------------------------
gem_array=(
  jekyll                  # For static blogging/Bootstrap
  s3_website              # For pushing to Amazon S3
  rdiscount               # Better faster markdown processing
  json                    # For search
  nokogiri                # For search
  rouge                   # For Bootstrap/Jekyll
  jekyll-sitemap          # Jekyll Sitemaps
  bundler
)

# ------------------------------------------------------------------------------
#                 Other modules we *may* want install
# ------------------------------------------------------------------------------
# cocoapods               # For building stuff

echo ""
cecho "===================================================" $white
cecho " 1) Installing/updating Ruby" $blue
cecho "===================================================" $white
echo ""

RUBY_PREFERRED=2.2.0

# Latest (stable) version of Ruby
RUBY_LATEST=$(rbenv install -l | sed -e 's/^[\t ]*//g'                  \
-e '/^[^0-9].*/d;/.*-\(dev\).*/d;/.*-\(preview\).*/d;/.*-\(rc\).*/d' \
| tail -1)

if [[ $RUBY_PREFERRED != $RUBY_LATEST ]]
  then
    cecho "There is a new Ruby version! Version: $RUBY_LATEST" $red
fi

# Install your preferred version of Ruby and set it as the global default:
# if [[ $(ruby -v) != "ruby 2.2.0p0 (2014-12-25 revision 49005) [x86_64-darwin14]" ]]
if [[ $(rbenv global) != $RUBY_PREFERRED ]]
  then
    rbenv install $RUBY_PREFERRED
    cecho "Installed Ruby version: $RUBY_PREFERRED" $white
    rbenv rehash
    rbenv global $RUBY_PREFERRED
    rbenv shell $RUBY_PREFERRED
  else
    cecho "Ruby version: $(rbenv global)" $white
fi

echo ""
cecho "===================================================" $white
cecho " 2) Installing/updating RubyGems" $blue
cecho "===================================================" $white
echo ""

cecho "Upgrade to the latest RubyGems" $white
# Update to the latest Rubygems version:
gem update --system

echo ""
cecho "===================================================" $white
cecho " 3) Installing/updating Gems" $blue
cecho "===================================================" $white

for i in "${gem_array[@]}"
do
  # If it's not installed then install it!
  if [[ -z $(gem query | grep $i) ]]
    then
      echo ""
      cecho "Installing $i" $green
      gem install $i
    else
      # If it's installed then update it!
      if [[ -n $(gem query | grep $i) ]]
        then
          echo ""
          cecho "Updating $i" $green
          gem update $i
      else
        cecho "How did we get here?" $red
      fi
  fi
done

echo ""
cecho "===================================================" $white
cecho " 4) Cleanup Ruby Gems" $blue
cecho "===================================================" $white
echo ""

# Clean up old versions of installed gems in the local repository
gem cleanup

# rehash rbenv shims (run this after installing executables)
rbenv rehash

echo ""
cecho "===================================================" $white
cecho " 5) Save a list of installed gems" $blue
cecho "===================================================" $white
echo ""

now=$(date +"%m_%d_%Y")
filename="${now}_ruby_gems.txt"

cecho "Saving list of installed gems" $white
gem list > $HOME/.osx-installer/whats-installed/$filename

echo ""
cecho "===================================================" $white
cecho " 6) All Done!" $blue
cecho "===================================================" $white
echo ""
