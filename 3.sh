#!/bin/bash

# https://github.com/Piercing666

# Check if running as root. If root, script will exit
if [[ $EUID -eq 0 ]]; then
    echo "This script should not be executed as root! Exiting......."
    exit 1
fi


# You will still need to install:
# Just Perfection
# Blur My Shell




# Customizations

gsettings set org.gnome.desktop.interface clock-format 24h
gsettings set org.gnome.desktop.interface clock-show-weekday true
gsettings set org.gnome.desktop.peripherals.keyboard numlock-state true
gsettings set org.gnome.desktop.input-sources xkb-options "['caps:backspace']"
gsettings set org.gnome.desktop.peripherals.mouse.speed "0.11790393013100431"
gsettings set org.gnome.desktop.peripherals.mouse.accel-profile "'flat'"
dconf write /org/gnome/desktop/privacy/report-technical-problems 'false'
dconf write /org/gnome/desktop/wm/preferences/focus-mode 'mouse'
dconf write /org/gnome/desktop/peripherals/touchpad/accel-profile 'flat'
dconf write /org/gnome/desktop/interface/font-name 'MesloLGSDZ Nerd Font 11'
dconf write /org/gnome/desktop/interface/document-font-name 'FiraCode Nerd Font 11'
dconf write /org/gnome/desktop/interface/monospace-font-name 'Terminus (TTF) Medium 12'
dconf write /org/gnome/desktop/wm/preferences/button-layout 'appmenu:close'
dconf write /org/gnome/system/location/enabled 'false'
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false
gsettings set org.gnome.settings-daemon.plugins.power idle-delay "uint32 900"
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.desktop.interface enable-hot-corners false
gsettings set org.gnome.desktop.background picture-options 'spanned'
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-automatic false
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-from 20
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-to 04
gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature 2500
gsettings set org.gnome.mutter.wayland.keybindings.restore-shortcuts "['']" 
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true
gsettings set org.gnome.desktop.peripherals.touchpad click-method 'areas'
gsettings set org.gnome.settings-daemon.plugins.power power-button-action 'interactive'
gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark
gsettings set org.gnome.desktop.interface cursor-theme 'Nordzy-cursors'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus'
gsettings set org.gnome.shell favorite-apps "['waterfox.desktop', 'org.gnome.Nautilus.desktop', 'org.libreoffice.LibreOffice.writer.desktop', 'org.gnome.Calculator.desktop', 'md.obsidian.Obsidian.desktop', 'com.visualstudio.code.desktop', 'code.desktop', 'synochat.desktop', 'org.gimp.GIMP.desktop', 'org.blender.Blender.desktop']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "<Super>c"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "flatpak run net.waterfox.waterfox"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "Waterfox"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name "kitty"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command "kitty"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding "<Super>W"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ binding "<Super>z"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ command "nautilus --new-window"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ name "Nautilus"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ binding "<Super>b"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ command "flatpak run md.obsidian.Obsidian"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ name "Obsisian"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/ binding "<Control><Alt>Delete"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/ command "flatpak run io.missioncenter.MissionCenter"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/ name "Mission Center"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/ binding "<Super>period"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/ command "flatpak run com.tomjwatson.Emote"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/ name "Emoji"
gsettings set org.gnome.desktop.wm.keybindings close "['<Super>Q']"
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal kitty
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal new-tab true
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal flatpak system
dconf write /org/gnome/settings-daemon/plugins/media-keys/control-center "['<Super>s']"
dconf write /org/gnome/shell/keybindings/toggle-quick-settings "[]"
dconf write /org/gnome/shell/extensions/forge/keybindings/prefs-open "[]"
dconf write /org/gnome/settings-daemon/plugins/media-keys/logout "[]"
dconf write /org/gnome/settings-daemon/plugins/media-keys/screensaver "['<Super>Return']"
dconf write /org/gnome/shell/extensions/forge/move-pointer-focus-enabled 'true'
dconf write /org/gnome/shell/extensions/space-bar/shortcuts/open-menu "[]"
dconf write /org/gnome/shell/extensions/space-bar/shortcuts/enable-move-to-workspace-shortcuts 'true'
dconf write /org/gnome/desktop/interface/font-name 'MesloLGSDZ Nerd Font 11'
dconf write /org/gnome/desktop/interface/document-font-name 'FiraCode Nerd Font 11'
dconf write /org/gnome/desktop/interface/monospace-font-name 'Terminus (TTF) Medium 12'
dconf write /org/gnome/desktop/wm/preferences/button-layout 'appmenu:close'
dconf write /org/gnome/system/location/enabled 'false'
dconf write /org/gnome/desktop/privacy/report-technical-problems 'false'
gnome-extensions enable ubuntu-appindicators@ubuntu.com
gnome-extensions enable gsconnect@andyholmes.github.io
gnome-extensions enable awesome-tiles@velitasali.com
gnome-extensions enable aztaskbar@aztaskbar.gitlab.com
gnome-extensions enable blur-my-shell@aunetx
gnome-extensions enable caffeine@patapon.info
gnome-extensions enable just-perfection-desktop@just-perfection
gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com
gnome-extensions enable forge@jmmaranan.com
gnome-extensions enable pop-shell@system76.com
gnome-extensions enable space-bar@luchrioh
dconf write /org/gnome/shell/extensions/just-perfection/dash-icon-size "48"
dconf write /org/gnome/shell/extensions/just-perfection/animation "3"
dconf write /org/gnome/shell/extensions/just-perfection/startup-status "0"
dconf write /org/gnome/shell/extensions/just-perfection/app-menu-icon "false"
dconf write /org/gnome/shell/extensions/just-perfection/activities-button "false"
dconf write /org/gnome/shell/extensions/just-perfection/app-menu "false"
dconf write /org/gnome/shell/extensions/just-perfection/app-menu-label "false"
dconf write /org/gnome/shell/extensions/just-perfection/search "false"
dconf write /org/gnome/shell/extensions/just-perfection/theme "true"
dconf write /org/gnome/shell/extensions/caffeine/duration-timer "4"
dconf write /org/gnome/shell/extensions/awesome-tiles/gap-size-increments "1"
dconf write /org/gnome/shell/extensions/aztaskbar/favorites "false"
dconf write /org/gnome/shell/extensions/aztaskbar/main-panel-height "33"
dconf write /org/gnome/shell/extensions/aztaskbar/panel-on-all-monitors "false"
dconf write /org/gnome/shell/extensions/aztaskbar/show-panel-activities-button "false"
dconf write /org/gnome/shell/extensions/aztaskbar/icon-size "23"
dconf write /org/gnome/shell/extensions/blur-my-shell/brightness "1.0"
dconf write /org/gnome/shell/extensions/aztaskbar/indicator-color-focused "'rgb(246,148,255)'"
dconf write /org/gnome/shell/extensions/aztaskbar/indicator-color-running "'rgb(130,226,255)'"
dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-1 "'<Super><Shift>1'"
dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-10 "'<Super><Shift>0'"
dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-2 "'<Super><Shift>2'"
dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-3 "'<Super><Shift>3'"
dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-4 "'<Super><Shift>4'"
dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-5 "'<Super><Shift>5'"
dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-6 "'<Super><Shift>6'"
dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-7 "'<Super><Shift>7'"
dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-8 "'<Super><Shift>8'"
dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-9 "'<Super><Shift>9'"
dconf write /org/gnome/shell/extensions/space-bar/behavior/show-empty-workspaces 'false'
dconf write /org/gnome/shell/extensions/space-bar/behavior/toggle-overview 'false'
dconf write /org/gnome/shell/extensions/forge/stacked-tiling-mode-enabled 'false'
dconf write /org/gnome/shell/extensions/forge/tabbed-tiling-mode-enabled 'false'
dconf write /org/gnome/shell/extensions/forge/preview-hint-enabled 'false'
dconf write /org/gnome/shell/extensions/forge/window-gap-size 'uint32 7'
dconf write /org/gtk/gtk4/settings/color-chooser/selected-color "true, 1.0, 1.0, 1.0, 1.0"



