#!/bin/bash

defaults delete com.apple.dock recent-apps
defaults delete com.apple.dock persistent-others

dock_item() {
    printf '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>%s</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>', "$1"
}

defaults write com.apple.dock persistent-apps -array \
    "$(dock_item /Applications/Firefox.app)" \
    "$(dock_item /Applications/Spark\ Desktop.app)" \
    "$(dock_item /Applications/Warp.app)" \
    "$(dock_item /Applications/Slack.app)" \
    "$(dock_item /Applications/Visual\ Studio\ Code.app)" \
    "$(dock_item /Applications/Postico\ 2.app/)" \
    "$(dock_item /Applications/Obsidian.app)" \
    "$(dock_item /Applications/Notion.app)"

killall Dock