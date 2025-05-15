#!/bin/bash

echo "Creating configuration directories..."
mkdir -p ~/.config/i3 ~/.config/polybar ~/.config/picom ~/.themes/AmoledRed/gtk-{2.0,3.0,4.0}

# i3 Configuration
cat <<EOF > ~/.config/i3/config
set \$mod Mod4

bindsym \$mod+Return exec kitty
bindsym \$mod+Shift+q kill
bindsym \$mod+h focus left
bindsym \$mod+l focus right
bindsym \$mod+k focus up
bindsym \$mod+j focus down
bindsym \$mod+Shift+h move left
bindsym \$mod+Shift+l move right
bindsym \$mod+Shift+k move up
bindsym \$mod+Shift+j move down

gaps inner 10
gaps outer 5
border pixel 2
client.focused #AA0000 #880000 #FFFFFF #AA0000
client.unfocused #000000 #000000 #444444 #000000

exec --no-startup-id picom --config ~/.config/picom.conf
exec --no-startup-id polybar red-theme
EOF

# Polybar Configuration
cat <<EOF > ~/.config/polybar/config.ini
[bar/main]
background = #000000
foreground = #FF0000
border-color = #880000
height = 30
width = 100%
modules-left = i3
modules-center = date
modules-right = memory cpu battery

[module/i3]
type = internal/i3
foreground = #FF0000
background = #000000
line-color = #880000
index-sort = true
EOF

# Picom Configuration
cat <<EOF > ~/.config/picom.conf
blur-method = gaussian
corner-radius = 5
shadow = true
shadow-radius = 12
shadow-opacity = 0.6
inactive-opacity = 1
active-opacity = 1
EOF

# GTK Theme for all versions
cat <<EOF > ~/.themes/AmoledRed/gtk-2.0/gtkrc
gtk-color-scheme = "bg_color:#000000\nfg_color:#FF4444\ntext_color:#FFFFFF\nborder_color:#880000\nbutton_bg:#000000\nbutton_hover:#AA0000"

style "amored-button" {
    bg[NORMAL] = @button_bg
    bg[PRELIGHT] = @button_hover
    fg[NORMAL] = @fg_color
    border[NORMAL] = @border_color
    border[PRELIGHT] = @border_color
}
widget_class "*" style "amored-button"
EOF

cat <<EOF > ~/.themes/AmoledRed/gtk-3.0/gtk.css
@define-color bg_color #000000;
@define-color fg_color #FF4444;
@define-color text_color #FFFFFF;
@define-color border_color #880000;
@define-color button_bg #000000;
@define-color button_hover #AA0000;

window {
    background-color: @bg_color;
    color: @text_color;
}
button {
    background-color: @button_bg;
    color: @fg_color;
    border-radius: 5px;
    border: 2px solid @border_color;
}
button:hover {
    background-color: @button_hover;
}
EOF

cat <<EOF > ~/.themes/AmoledRed/gtk-4.0/gtk.css
@define-color bg_color #000000;
@define-color fg_color #FF4444;
@define-color text_color #FFFFFF;
@define-color border_color #880000;
@define-color button_bg #000000;
@define-color button_hover #AA0000;

window {
    background-color: @bg_color;
    color: @text_color;
}
button {
    background-color: @button_bg;
    color: @fg_color;
    border-radius: 5px;
    border: 2px solid @border_color;
}
button:hover {
    background-color: @button_hover;
}
EOF

# DXVK Settings
echo "export DXVK_HUD=1" | sudo tee -a /etc/environment
echo "export WINEPREFIX=~/.wine" | sudo tee -a /etc/environment

# Gamescope alias
echo 'alias fsr="gamescope -w 1920 -h 1080 -Fsr"' >> ~/.bashrc

# Enable startup services
sudo systemctl enable gamemoded gamescope NetworkManager

echo "All configurations have been applied!"