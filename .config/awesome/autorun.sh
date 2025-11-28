#!/usr/bin/env bash

# Autorun script para iniciar aplicativos no login
# Este script deve ser chamado no arquivo rc.lua do awesomewm

# Lista de aplicativos para iniciar (formato: "Nome do Processo|Comando")
declare -A STARTUP_APPS=(
    ["gammastep"]="gammastep &"
    ["nm-applet"]="nm-applet &"
    ["xfce4-clipman"]="xfce4-clipman &"
    ["openrgb"]="openrgb --startminimized &"
    ["polkit-gnome"]="sleep 1 && /usr/libexec/polkit-gnome-authentication-agent-1 &"
    # ["power.conf"]="sh $HOME/.config/X11/power.conf &"
)

start_services() {
    for process in "${!STARTUP_APPS[@]}"; do
        if ! pgrep -x "$process" >/dev/null; then
            echo "Iniciando: $process"
            eval "${STARTUP_APPS[$process]}"
        else
            echo "[JÁ EM EXECUÇÃO] $process"
        fi
    done
}

main() {
    start_services
    exit 0
}

main