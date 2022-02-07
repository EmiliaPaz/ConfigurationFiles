# iTerm2 Settings

## Preferences

### Appearance
Theme: Minimal

### Keys
#### Key bindings
| Keyboard shortcut | Action               |      | Explanation                     |
| ----------------- | -------------------- |------|---------------------------------|
| cmd + <-          | Send Hex Code        | 0x01 | Go to the beggining of the line |
| cmd + ->          | Send Hex Code        | 0x05 | Go to the end of the line       |
| cmd + b           | Send Escape Sequence | b    | Go to the beggining of the word |
| cmd + e           | Send Escape Sequence | f    | Go to the end of the word |


## zsh

### Oh My Zsh
Install: https://ohmyz.sh/#install
#### Customize
- [Autosuggestions](https://github.com/zsh-users/zsh-autosuggestions):
  - Clone this repository into $ZSH_CUSTOM/plugins 

        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions  
  - Add the plugin to the list of plugins for Oh My Zsh to load (inside ~/.zshrc):

        plugins=(zsh-autosuggestions)

