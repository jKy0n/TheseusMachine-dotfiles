# Ranger Cheatsheet

## General
Shortcut | Description 
---|---
`ranger` | Start Ranger
`Q` | Quit Ranger
`R` | Reload current directory
`?` | Ranger Manpages / Shortcuts


## Movement
Shortcut | Description 
---|---
`k` | up
`j` | down
`h` | parent directory
`l`| subdirectory
`gg` | go to top of list
`G` | go t bottom of list
`J` | half page down
`K` | half page up
`H` | History Back
`L` | History Forward
`~` | Switch the view

## File Operations
Shortcut | Description 
---|---
`<Enter>` | Open
`r` | open file with 
`z` | toggle settings
`o` | change sort order
`zh` | view hidden files
`cw` | rename current file
`yy` | yank / copy
`dd` | cut
`pp` | paste
`/` | search for files `:search`
`n` | next match
`N` | prev match
`<delete>` | Delete

  
## Commands
Shortcut | Description 
---|---
`:` | Execute Range Command
`!` | Execute Shell Command
`chmod` | Change file Permissions
`du` | Disk Usage Current Directory
`S` | Run the terminal in your current ranger window (exit to go back to ranger)

## Tabs
Shortcut | Description 
---|---
`C-n` | Create new tab
`C-w` | Close current tab
tab | Next tab
shift + tab | Previous tab
alt + [n] | goto / create [n] tab

## File substituting
Shortcut | Description 
---|---
`%f` | Substitute highlighted file
`%d` | Substitute current directory
`%s` | Substitute currently selected files
`%t` | Substitute currently tagged files

### Example for substitution
`:bulkrename %s`

## Marker
Shortcut | Description 
---|---
`m  + <letter>` | Create Marker
`um  + <letter>` | Delete Marker
`'  + <letter>` | Go to Marker
`t` | tag a file with an *
`t"<any>` | tag a file with your desired mark

_thx to the comments section for additional shortcuts! post your suggestions there!_




