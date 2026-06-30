#!/usr/bin/env bash
#
# macForge - macOS System Defaults
#
# This script applies sensible system preferences.
# Feel free to edit or add your own `defaults` commands.
#
# Run with: ./scripts/macos-defaults.sh
# (It is also called by the main install script)

set -euo pipefail

# Close any open System Preferences panes to prevent overriding
osascript -e 'tell application "System Preferences" to quit' 2>/dev/null || true

echo "Applying macOS defaults..."

# -----------------------------------------------------------------------------
# General UI / UX
# -----------------------------------------------------------------------------
# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Disable automatic capitalization, smart dashes, period substitution, smart quotes
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# -----------------------------------------------------------------------------
# Trackpad, mouse, keyboard
# -----------------------------------------------------------------------------
# Enable tap to click for this user and the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Increase sound quality for Bluetooth headphones/headsets
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

# Enable full keyboard access for all controls
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# -----------------------------------------------------------------------------
# Dock
# -----------------------------------------------------------------------------
# Set Dock size
defaults write com.apple.dock tilesize -int 48

# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool true

# Don’t show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

# Autohide Dock
defaults write com.apple.dock autohide -bool false

# Enable magnification
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -float 64

# Change minimize effect to scale (suck effect can be annoying)
defaults write com.apple.dock mineffect -string "scale"

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

# -----------------------------------------------------------------------------
# Finder
# -----------------------------------------------------------------------------
# Show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Use list view in all Finder windows by default
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# -----------------------------------------------------------------------------
# Screenshots
# -----------------------------------------------------------------------------
# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

# Save screenshots in PNG format
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# -----------------------------------------------------------------------------
# Terminal & iTerm (if used later)
# -----------------------------------------------------------------------------
# Only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4

# -----------------------------------------------------------------------------
# iTerm2 specific preferences (basic)
# -----------------------------------------------------------------------------
# Don't prompt on quit
defaults write com.googlecode.iterm2 PromptOnQuit -bool false

# Use modern theme / settings can be further customized in iTerm itself
# For full iTerm2 prefs, export from iTerm → Settings → General → Preferences
# and place the file in configs/iterm2/ (future enhancement)

# -----------------------------------------------------------------------------
# Activity Monitor
# -----------------------------------------------------------------------------
# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

# -----------------------------------------------------------------------------
# Hot Corners (Mission Control)
# -----------------------------------------------------------------------------
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# 13: Lock Screen

# Bottom left → Desktop
defaults write com.apple.dock wvous-bl-corner -int 4
defaults write com.apple.dock wvous-bl-modifier -int 0

# Top right → Mission Control
defaults write com.apple.dock wvous-tr-corner -int 2
defaults write com.apple.dock wvous-tr-modifier -int 0

# -----------------------------------------------------------------------------
# Keyboard & Input
# -----------------------------------------------------------------------------
# Enable keyboard navigation in dialogs
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Faster key repeat (already set earlier, ensure)
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# -----------------------------------------------------------------------------
# Finder - Additional
# -----------------------------------------------------------------------------
# Show the ~/Library folder
chflags nohidden ~/Library 2>/dev/null || true

# Show the /Volumes folder
sudo chflags nohidden /Volumes 2>/dev/null || true

# Enable spring loading for directories
defaults write NSGlobalDomain com.apple.springing.enabled -bool true
defaults write NSGlobalDomain com.apple.springing.delay -float 0.5

# -----------------------------------------------------------------------------
# Trackpad
# -----------------------------------------------------------------------------
# Enable three finger drag (very useful)
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true

# -----------------------------------------------------------------------------
# Menu Bar & Battery
# -----------------------------------------------------------------------------
# Show battery percentage
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# Clock format: EEE MMM d  h:mm a   (e.g. Mon Jun 29  3:42 PM)
defaults write com.apple.menuextra.clock DateFormat -string "EEE MMM d  h:mm a"

# -----------------------------------------------------------------------------
# Other Quality of Life
# -----------------------------------------------------------------------------
# Disable the "Are you sure you want to open this application?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Expand the "Open with" and "Sharing & Permissions" panes in Finder Get Info
defaults write com.apple.finder FXInfoPanesExpanded -dict \
    OpenWith -bool true \
    Privileges -bool true

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# -----------------------------------------------------------------------------
# Restart affected apps
# -----------------------------------------------------------------------------
for app in "Dock" "Finder" "SystemUIServer"; do
  killall "${app}" &>/dev/null || true
done

echo "macOS defaults applied. Some changes may require a logout/restart."
