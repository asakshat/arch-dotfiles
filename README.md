# My Dotfiles for Arch-Linux (Endeavour OS) with i3WM

This repository contains my personal dotfiles for a Linux setup using Arch Endeavour OS with the i3 window manager. Made it to reproduce same settings/configs in different machines. Most of the themes and configs were taken from
rofi-themes and polybar-themes. I customized the given template , made some of my own widgets and scripts for the rest.

Currently , I'm working on a custom bar with widgets using Elkowar's Wacky Widgets (EWW) . Most of the polybar configs that im using at the moment are presets made by someone else which don't work the same in my system and I have to tweak them a lot to work for me. At that point , why not make my own UI ? Amirite ?

## Pictures

There are other small scripts included which are not shown below .

<details>
  <summary>Polybar</summary>
  
  ![polybar](./images/1.png 'polybar')
  
</details>

<details>
  <summary>Fastfetch</summary>
  
  ![fastfetch](./images/2.png 'fastfetch')
  
</details>
<details>
  <summary>Rofi-Launcher (preset)</summary>
  
  ![launcher](./images/3.png 'launcher')
  
</details>

<details>
  <summary>Network Manager Widget w/ Rofi (custom made)</summary>
  
  ![nmcli](./images/4.png 'nmcli')
  
</details>
<details>
  <summary>Clipboard Manager (custom made)</summary>
  
  ![clipboard](./images/6.png 'clipboard')
  
</details>

<details>
  <summary>Powermenu (preset)</summary>
  
  ![powermenu](./images/5.png 'powermenu')
  
</details>
<br>

## Overview

- **OS**: Arch Endeavour OS
- **Window Manager**: i3wm
- **Shell**: zsh with zinnit
- **Terminal**: Alacritty
- **Compositor**: Picom
- **GTK-THEME**: Tokyonight
- **Notification-Daemon**: Dunst
- **Bar**: Polybar
- **UI/Widgets**: Made using Rofi

## Dependencies

Before installing the dotfiles, ensure you have the following dependencies installed on your system:

```
zoxide fzf zsh picom alacritty dunst polybar rofi xclip greenclip maim nmcli pipewire betterlockscreen networkmanager_dmenu feh
```

A lot of the dependencies are already preinstalled with endeavour OS and I probably have missed some dependencies but just follow the errors.

## Usage

```bash
git clone https://github.com/asakshat/arch-dotfiles.git ~/dotfiles
cd ~/dotfiles
```

Use GNU Stow to manage the files or just copy whatever you need to $HOME/.config/
