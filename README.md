## The hacker's guide to managing your Mac

This is a modular installer framework that has two main goals:

1. Be able to bootstrap a new system **quickly** with a **repeatable** process.
2. Keep all software updated regularly (and keep track of what is installed).

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

## Bootstrapping a new system

  1. [ ] Install the OS (in case this isn't a brand new system and you are reloading)
  2. [ ] Install all updates.  Yes, seriously, even on a new system. Also **turn on automatic updates** - you will be prompted to do so on a new system.
  3. [ ] Run Diskutil and check disk and repair permissions. Yup, really.
  4. [ ] This is a brand new, fresh system. Do a full, complete backup as your starting point!
  5. [ ] Go ahead and manually install your printer via "System Preferences/Printers & Scanners" at this point.
  5. [ ] Go to the App Store and install your App Store apps at this point. This **must** include Xcode.
  6. [ ] Open Xcode and agree to the license agreement(s) and download the iOS simulator and docs via Xcode preferences.
  7. [ ] I recommend another backup at this point.  Consider this is your baseline system.
  8. [ ] Clone the .osx-installer repository (NOTE: this step causes the Xcode command line tools to be installed.):
    ```
    git clone https://github.com/dstroot/.osx-installer.git ~/.osx-installer && cd ~/.osx-installer
    ```
  9. [ ] Make the scripts executable:
    ```
    find . -type f -name "*.sh" -exec chmod u+x {} \;
    ```
  10. [ ] Run the install script `~/.osx-installer/install.sh` and answer "y" at the prompts... wait for it ... **BOOM!**
  11. [ ] Sign into Drobox and let your files **fully** sync.
  12. [ ] Run `mackup restore` at the command line to restore your dotfiles configuration. You will have to answer "Yes" at the prompts.  If this is your first build just type `mackup backup` instead to back it up.
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

## Bugs

If you run into any issues, please [open an issue](https://github.com/dstroot/dotfiles/issues) on this repository and I'd love to get it fixed.  Or, pull requests are always appreciated.
