
export HISTFILE="$HOME/.config/zsh/zshrc.d/zsh-secrets/histfile"
export HISTSIZE=10000
export SAVEHIST=10000

# Configurações de histórico
setopt inc_append_history      # Adiciona comandos ao histórico imediatamente
setopt share_history           # Compartilha o histórico entre sessões
setopt hist_ignore_all_dups    # Ignora duplicatas no histórico
setopt hist_reduce_blanks      # Remove espaços em branco redundantes
setopt hist_verify             # Verifica o comando antes de executá-lo
setopt hist_ignore_space   