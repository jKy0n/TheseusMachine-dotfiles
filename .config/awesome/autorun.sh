#!/usr/bin/env bash

# Autorun script para iniciar aplicativos no login
# Este script deve ser chamado no arquivo rc.lua do awesomewm

# Lista de aplicativos para iniciar (formato: "Nome do Processo|Comando")
declare -A STARTUP_APPS=(
    # Gammastep é um aplicativo de ajuste de temperatura de cor para reduzir a fadiga ocular
    ["gammastep"]="gammastep &"
    # snixembed é um aplicativo para integrar aplicativos do SnixOS com o ambiente de desktop
    ["snixembed"]="snixembed --fork &"
    # kdeconnectd é o daemon do KDE Connect, que permite a integração entre dispositivos móveis e o desktop
    ["kdeconnectd"]="kdeconnectd &"
    # kdeconnect-indicator é um aplicativo que mostra o status do KDE Connect na bandeja do sistema
    ["kdeconnect-indicator"]="kdeconnect-indicator &"
    # nm-applet é o applet de rede do NetworkManager, que permite gerenciar conexões de rede
    ["nm-applet"]="nm-applet &"
    # blueman-applet é o applet de Bluetooth do Blueman, que permite gerenciar conexões Bluetooth
    ["blueman-applet"]="blueman-applet &"
    # xfce4-clipman é o gerenciador de área de transferência do Xfce, que permite acessar o histórico da área de transferência
    ["xfce4-clipman"]="xfce4-clipman &"
    # openrgb é um aplicativo para controlar a iluminação RGB de dispositivos compatíveis
    ["openrgb"]="openrgb --startminimized &"
    # polkit-gnome é o agente de autenticação do PolicyKit para GNOME, que gerencia permissões de aplicativos
    ["polkit-gnome"]="sleep 1 && /usr/libexec/polkit-gnome-authentication-agent-1 &"
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