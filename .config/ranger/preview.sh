#!/bin/bash
if [[ "$1" == "$HOME/.config/ranger/cheatsheet.md" ]]; then
    glow "$1"
else
    highlight --out-format=xterm256 "$1" || cat "$1"
fi
