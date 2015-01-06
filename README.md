## The hacker's guide to managing your Mac

The purpose of this repository is to be able to manage my MacBook like a boss. Are you a small startup without a devops team or a lone wolf? Do you want to mange your mac like a boss too? Then read on.  

This means:

1. Be able to bootstrap a new system **quickly** with a **repeatable** process.
2. Keep all software updated regularly (and keep track of what is installed).
3. Have a great set of OSX defaults.
4. Have a **very** productive development environment:
  1. A great shell environment
    - Aliases
    - Fonts
    - Colors
    - Prompt
    - etc.
  2. A great editor enviroment
    - Colors
    - Fonts
    - Packages
    - Keys
    - Snippets
    - etc.

## Building Blocks

We want to use the best tools out there - e.g. the ones with the most community support and momentum and the best functionality.

* **Shell: Zsh**. Zsh is awesome, really. To use Zsh like a boss install [.oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh). It autoupdates, has great plugins and a very active community behind it. Your settings will be backed up by Mackup below. Resources:
  - [Why Zsh](http://code.joejag.com/2014/why-zsh.html)
  - [pure prompt](https://github.com/sindresorhus/pure)
* **Terminal: iTerm2** for our terminal program. [iTerm2](http://iterm2.com/) is free and it rocks. Your settings will be backed up by Mackup. Resources:
  - [Iterm2-color-schemes](http://iterm2colorschemes.com/)
  - Font: Source Code Pro Light
* **Editor: Sublime Text** (or **Atom?**) as our code editor.  Your settings, packages, etc. will all be backed up by Mackup.
  - For now we are installing **both** Sublime Text and Atom.
* **Tool Version Management: n and rbenv**. Manage your Ruby and Node versions:
  - [n](https://github.com/tj/n) for node (other possibilities: NVM)
  - [rbenv](https://github.com/sstephenson/rbenv) for [Ruby](https://www.ruby-lang.org/en/) (Other possibilities: RVM )
* **Package Management: Homebrew, homebrew cask, npm, pip**.  Installing Binaries with [homebrew](http://brew.sh/). Homebrew is a community-driven package installer and an essential tool for every hacker's toolkit. Homebrew automates the setup, compiling and linking of binaries. It also makes updating and uninstalling binaries a breeze. Resources:
  - [About Homebrew](http://mac.tutsplus.com/tutorials/terminal/homebrew-demystified-os-xs-ultimate-package-manager/)
* **Homebrew cask**. Installing Apps (and fonts!) with homebrew [cask](http://caskroom.io/).  Homebrew Cask is an extension for Homebrew that allows you to automate the installation of Mac Apps and Fonts.
* **Backup: Mackup**. Backing up and Restoring our .dotfiles (our configuration) with [mackup](https://github.com/lra/mackup).  Mackup is a community-driven tool for backing up and restoring system and application settings. See dotfiles section below.
* **Default OSX Configuration: .osx**. Solid defaults based on [Mathias Bynens](https://mathiasbynens.be) ledgendary [OSX script](https://github.com/mathiasbynens/dotfiles/blob/master/.osx), but highly modularized. Maintained separately in `.osx`.
* **Dot Script**. Bringing it all together with a `dot` script that keeps everything updated.

## Dotfiles Management

Dotfiles, so called because the filename begins with a `.` are found in a user's home directory. These files are normally hidden from view and are created/modified as you install and configure your machine.

Initially people created a directory called `.dotfiles`, moved their dotfiles there, and symlinked them back to their original locations. Then they turned this into a git repository so they can save and version changes, back them up to GitHub, and use them across machines. Pretty cool right?

However there are some downsides to this approach:
* Your configuration is only backed up when you do a commit and a push.  If you don't do this often then your most recent changes are not saved.
* Since these are "your" configuration files they may have sensitive information in them like passwords and such.  You can pay for private repositories on GitHub, or go through hoops to make sure your confidential data is not committed.  However if it's not committed in a repository where is it?  Is it backed up?
* By focusing on dotfiles there are a number of other things that don't get backed up. You can address them in a similar way - moving the files into your dotfiles folder and symlinking them back but **you** have to be aware of them first.  For example which Atom or Sublime Text packages do you have installed?

##### Enter [Mackup](https://github.com/lra/mackup):

Mackup takes your dotfiles and backs them up to dropbox (so we have a prerequisite that dropbox is installed - note homebrew can install both Dropbox and Mackup) and then symlinks them back as discussed above. But it's also much more than that - it understands applications and where they store configuration data and how to save it.

Advantages:
* Dropbox is private by default (if you trust it's security) so you don't have to worry about your private information being committed to a public github repository.
* Dropbox syncs automatically so your dotfiles are **automatically and continously** backed up from that point forward.
* Mackup understands applications and where they stash configuration data and **also** backs that up for you.  

## Bootstrapping a new system

  1. [ ] Install the OS (in case this isn't a brand new system and you are reloading)
  2. [ ] Install all updates.  Yes, seriously, even on a new system. Also **turn on automatic updates** - you will be prompted to do so on a new system.
  3. [ ] Run Diskutil and check disk and repair permissions. Yup, we're anal here.
  4. [ ] This is a brand new, fresh system. Do a full, complete backup as your starting point! Timemachine works pretty well. :)
  5. [ ] Go ahead and manually install your printer via "System Preferences/Printers & Scanners" at this point.
  5. [ ] Go to the App Store and install your App Store apps at this point. This must include Xcode.
  6. [ ] Open Xcode and agree to the license agreement(s) and download the iOS simulator and docs via Xcode preferences.
  7. [ ] I recommend another backup at this point.  This is your baseline system.
  8. [ ] Clone the .dotfiles repository (NOTE: this step causes the Xcode command line tools to be installed.):
    ```
    git clone https://github.com/dstroot/dotfiles.git ~/.dotfiles && cd ~/.dotfiles
    ```
  9. [ ] Make the scripts executable:
    ```
    find . -type f -name "*.sh" -exec chmod u+x {} \;
    ```
  10. [ ] Run the install script `~/.dotfiles/osx/install.sh` and answer "y" at the prompts... wait for it ... **BOOM!**
  11. [ ] Sign into Drobox and let your files **fully** sync.
  12. [ ] Run `after_dropbox_sync.sh` at the command line to restore your configuration. You will have to answer "Yes" at the prompts.  If this is your first build just type `mackup backup` instead.
  13. [ ] If using Time Machine open it's preferences and manually exclude: ~/Dropbox, ~/Code and possibly ~/Go (already backed up/managed elsewhere).
  14. [ ] If using Sublime Text don't forget to add your license.

### What the install script does:

  1. Prompts you to install Apple App Store Apps (should be done already)
  2. Installs Xcode command-line tools (should be done already)
  3. Installs .oh-my-zsh
  4. Installs Homebrew & "stuff" (must be ahead of Ruby because it installs rbenv)
  5. Installs Node/NPM and NPM global modules
  6. Installs Ruby/Ruby Gems (managed by rbenv)
  7. Installs Python (PIP) Stuff
  8. Installs Google Fonts
  9. Installs Go
  10. Sets up Autofs (fileshares)
  11. Prompts you to manually install apps
  12. Prompts you to setup Microsoft Office
  13. Installs `.osx` and applies OSX defaults

### Maintenance script (dot script):

`dot` is a simple script that keeps everything tip top. Occasionally run `dot` from time to time to keep your environment fresh and up-to-date. You can find this script in `~/.dotfiles/bin/`.

## What's Inside

A lot of stuff. Seriously, a **lot** of stuff.

### Other Key Scripts

- `~/.dotfiles/homebrew/brew.sh` - installs/updates Homebrew and all apps that can be installed via Homebrew/homebrew cask.
- `~/.dofiles/npm/npm.sh` - installs node, npm and npm global modules
- `~/.dotfiles/ruby/gems.sh` - installs Ruby Gems.
- `~/.dotfiles/pip/pip.sh` - installs python pip modules.
- `~/.osx/osx-defaults.sh` - sets all OSX defaults just the way I like 'em.  ;)  
  - Here is a good reference [OSX Default Values Command Reference](https://github.com/kevinSuttle/osxdefaults/blob/master/REFERENCE.md)
- `~/.dotfiles/after_dropbox_sync.sh` - runs `mackup restore` and links my Desktop folder to Dropbox/Desktop.

### Components

- Anything with an extension of `.zsh` in `~/.oh-my-zsh/custom` will get automatically included into your shell.
- Anything in `~/.dotfiles/bin/` is in your `$PATH` and available everywhere.

## Aliases (trying to keep them all documented here)

__type:__ `alias` (Boy I wish readme's supported GFM - then the list below would not be gibberish)

| Alias | = | This    |
| ----- | - | ----    |
| -     | = | 'cd -'  |
| ..    | = | 'cd ..' |
| ...   | = | 'cd ../..' |
| 1     | = | 'cd -'  |
| 2     | = | 'cd -2' |
| 3     | = | 'cd -3' |
| 4     | = | 'cd -4' |
| 5     | = | 'cd -5' |
| 6     | = | 'cd -6' |
| 7     | = | 'cd -7' |
| 8     | = | 'cd -8' |
| 9     | = | 'cd -9' |
| _     | = | sudo    |
| afind | = | 'ack-grep -il' |
| at    | = | 'open -a '\''/Applications/Atom.app'\' |
| att   | = | 'at .' |
| bi    | = | 'bower install' |
| bl    | = | 'bower list' |
| bs    | = | 'bower search' |
| cd..  | = | 'cd ..' |
| cd... | = | 'cd ../..' |
| cd.... | = | 'cd ../../..' |
| cd..... | = | 'cd ../../../..' |
| cd/ | = | 'cd /' |
| d | = | 'dirs -v 'pipe' head -10' |
| dl | = | 'cd ~/Downloads' |
| drop | = | 'cd ~/Dropbox' |
| dt | = | 'cd ~/Desktop' |
| g | = | git |
| ga | = | 'git add' |
| gap | = | 'git add --patch' |
| gb | = | 'git branch' |
| gba | = | 'git branch -a' |
| gbr | = | 'git branch --remote' |
| gc | = | 'git commit -v' |
| 'gc!' | = | 'git commit -v --amend' |
| gca | = | 'git commit -v -a' |
| 'gca!' | = | 'git commit -v -a --amend' |
| gcl | = | 'git config --list' |
| gclean | = | 'git reset --hard && git clean -dfx' |
| gcm | = | 'git checkout master' |
| gcmsg | = | 'git commit -m' |
| gco | = | 'git checkout' |
| gcount | = | 'git shortlog -sn' |
| gcp | = | 'git cherry-pick' |
| gcs | = | 'git commit -S' |
| gd | = | 'git diff' |
| gdc | = | 'git diff --cached' |
| gdt | = | 'git difftool' |
| gg | = | 'git gui citool' |
| gga | = | 'git gui citool --amend' |
| ggpnp | = | 'git pull origin $(current_branch) && git push origin $(current_branch)' |
| ggpull | = | 'git pull origin $(current_branch)' |
| ggpur | = | 'git pull --rebase origin $(current_branch)' |
| ggpush | = | 'git push origin $(current_branch)' |
| gignore | = | 'git update-index --assume-unchanged' |
| gignored | = | 'git ls-files -v 'pipe' grep "^[[:lower:]]"' |
| git-svn-dcommit-push | = | 'git svn dcommit && git push github master:svntrunk' |
| gitkey | = | 'more ~/.ssh/github_rsa.pub 'pipe' pbcopy 'pipe' echo '\''=> Public key copied to pasteboard.'\' |
| gk | = | 'gitk --all --branches' |
| gl | = | 'git pull' |
| glg | = | 'git log --stat --max-count=10' |
| glgg | = | 'git log --graph --max-count=10' |
| glgga | = | 'git log --graph --decorate --all' |
| glo | = | 'git log --oneline --decorate --color' |
| globurl | = | 'noglob urlglobber ' |
| glog | = | 'git log --oneline --decorate --color --graph' |
| glp | = | 'git_log_prettily' |
| gm | = | 'git merge' |
| gmt | = | 'git mergetool --no-prompt' |
| gp | = | 'git push' |
| gpoat | = | 'git push origin --all && git push origin --tags' |
| gr | = | 'git remote' |
| grba | = | 'git rebase --abort' |
| grbc | = | 'git rebase --continue' |
| grbi | = | 'git rebase -i' |
| grep | = | 'grep --color=auto --exclude-dir={.bzr,.cvs,.git,.hg,.svn}' |
| grh | = | 'git reset HEAD' |
| grhh | = | 'git reset HEAD --hard' |
| grmv | = | 'git remote rename' |
| grrm | = | 'git remote remove' |
| grset | = | 'git remote set-url' |
| grt | = | 'cd $(git rev-parse --show-toplevel 'pipe''pipe' echo ".")' |
| grup | = | 'git remote update' |
| grv | = | 'git remote -v' |
| gsd | = | 'git svn dcommit' |
| gsps | = | 'git show --pretty=short --show-signature' |
| gsr | = | 'git svn rebase' |
| gss | = | 'git status -s' |
| gst | = | 'git status' |
| gsta | = | 'git stash' |
| gstd | = | 'git stash drop' |
| gstp | = | 'git stash pop' |
| gsts | = | 'git stash show --text' |
| gts | = | 'git tag -s' |
| gunignore | = | 'git update-index --no-assume-unchanged' |
| gunwip | = | 'git log -n 1 'pipe' grep -q -c "\-\-wip\-\-" && git reset HEAD~1' |
| gup | = | 'git pull --rebase' |
| gvt | = | 'git verify-tag' |
| gwc | = | 'git whatchanged -p --abbrev-commit --pretty=medium' |
| gwip | = | 'git add -A; git ls-files --deleted -z 'pipe' xargs -r0 git rm; git commit -m "--wip--"' |
| history | = | 'fc -l 1' |
| ios | = | 'open /Applications/Xcode.app/Contents/Developer/Applications/'\''iOS Simulator.app'\' |
| l | = | 'ls -lah' |
| la | = | 'ls -lAh' |
| ll | = | 'ls -lh' |
| ls | = | 'ls -G' |
| lsa | = | 'ls -lah' |
| md | = | 'mkdir -p' |
| ohmyzsh | = | 'atom ~/.oh-my-zsh' |
| please | = | sudo |
| po | = | popd |
| pu | = | pushd |
| pubkey | = | 'more ~/.ssh/id_dsa.public 'pipe' pbcopy 'pipe' echo '\''=> Public key copied to pasteboard.'\' |
| q | = | exit |
| rd | = | rmdir |
| 'reload!' | = | '. ~/.zshrc' |
| router | = | 'command -v route && open http://192.168.15.1' |
| run-help | = | man |
| serve | = | 'python -m SimpleHTTPServer' |
| st | = | subl |
| stt | = | 'st .' |
| subl | = | \''/usr/local/bin/subl'\' |
| which-command | = | whence |
| x | = | extract |
| z | = | 'z 2>&1' |
| zshconfig | = | 'atom ~/.zshrc' |

## Bugs

If you run into any issues, please [open an issue](https://github.com/dstroot/dotfiles/issues) on this repository and I'd love to get it fixed.  Or, pull requests are always appreciated.

## Thanks

- I forked [Zach Holman's](http://github.com/holman)' excellent [dotfiles](http://github.com/holman/dotfiles) as my initial starting point.  I liked his organization and approach.
- Much of the OSX defaults script comes from [Mathias Bynens'](https://github.com/mathiasbynens/) amazing [dotfiles](https://github.com/mathiasbynens/dotfiles). Mathias' OSX defaults script is legendary.
