# ~/.zshrc.d/keybinds.zsh

bindkey -e

# Configuração para a tecla Delete
bindkey '^[[3~' delete-char

# Tecla Home para ir ao início da linha
bindkey '^[OH' beginning-of-line

# Tecla End para ir ao fim da linha
bindkey '^[OF' end-of-line

# Ctrl + seta para a esquerda para mover uma palavra para trás
bindkey '^[[1;5D' backward-word

# Ctrl + seta para a direita para mover uma palavra para frente
bindkey '^[[1;5C' forward-word

# Configuração para Alt + Backspace para apagar uma palavra
bindkey '\e^H' backward-kill-word

# 
bindkey '^[[1;3B' menu-complete

# Aceitar sugestões do autosuggestions com seta para a direita
bindkey '^[^[[C' autosuggest-accept

# Corrige seta para esquerda para navegação normal
bindkey '^[[D' backward-char