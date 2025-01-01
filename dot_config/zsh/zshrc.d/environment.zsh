# Variáveis de ambiente gerais
export HISTFILE="$HOME/.config/zsh/zshrc.d/zsh-secrets/histfile"
export HISTSIZE=10000
export SAVEHIST=10000

export EDITOR=nvim
export VISUAL=nvim

# Configurações de histórico
setopt inc_append_history      # Adiciona comandos ao histórico imediatamente
setopt share_history           # Compartilha o histórico entre sessões
setopt hist_ignore_all_dups    # Ignora duplicatas no histórico
setopt hist_reduce_blanks      # Remove espaços em branco redundantes
setopt hist_verify             # Verifica o comando antes de executá-lo
setopt hist_ignore_space       # Ignora comandos que começam com espaço

setopt autocd
setopt beep
setopt extendedglob
setopt notify

# Configurações adicionais, se aplicável
export QT_QPA_PLATFORMTHEME="qt6ct"
export PATH="$PATH:/usr/local/bin"

# Ativa o ambiente virtual do ShellGPT
if [ -d "$HOME/.venvs/shell-gpt/bin" ]; then
    source "$HOME/.venvs/shell-gpt/bin/activate"
else
    echo "ShellGPT environment not found at ~/.venvs/shell-gpt"
fi