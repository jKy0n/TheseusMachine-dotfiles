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

# Ativa o pay-respects
eval "$(pay-respects zsh --alias)"

# Configurações adicionais, se aplicável
export QT_QPA_PLATFORMTHEME="qt6ct"
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

export OMP_NUM_THREADS=28  # Usa todas as 28 threads do Ryzen
export OLLAMA_NUM_GPU=1    # Força uso da RX 7800 XT via ROCm (verifique compatibilidade)

if [ -n "$(tty)" ]; then
    export GPG_TTY=$(tty)
fi

# Ativa o ambiente virtual do ShellGPT
# if [ -d "$HOME/.venvs/shell-gpt/bin" ]; then
#     source "$HOME/.venvs/shell-gpt/bin/activate"
# else
#     echo "ShellGPT não encontrado. Certifique-se de que o ambiente virtual está instalado em ~/.venvs/shell-gpt"
# fi

# Recupera a senha GPG usando o Bitwarden CLI
# if command -v bw >/dev/null 2>&1; then
#     export GPG_PASSPHRASE=$(bw get password gpg-passphrase 2>/dev/null)
# else
#     echo "Bitwarden CLI não encontrado. Instale-o para gerenciar senhas com segurança."
# fi
