# ~/.zshrc.d/keybinds.zsh

# Apagar segmento de path com Ctrl+Backspace
delete-path-segment-backward() {
  local WORDCHARS_SAVE=$WORDCHARS
  WORDCHARS=${WORDCHARS_SAVE//\//}
  zle backward-kill-word
  WORDCHARS=$WORDCHARS_SAVE
}
zle -N delete-path-segment-backward delete-path-segment-backward


# Modo de edição (emacs ou vi)
bindkey -e  # Usando modo emacs

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
bindkey '^[[' backward-kill-word

# 
bindkey '^[[1;3B' menu-complete

# Aceitar sugestões do autosuggestions com seta para a direita
bindkey '^[^[[C' autosuggest-accept

# Corrige seta para esquerda para navegação normal
bindkey '^[[D' backward-char

# Ctrl+Backspace — ajuste o código se necessário
bindkey "^H" delete-path-segment-backward