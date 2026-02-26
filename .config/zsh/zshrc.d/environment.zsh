# Variáveis de ambiente gerais

export EDITOR=nvim
export VISUAL=nvim
export SYSTEMD_EDITOR=nvim

# export QT_QPA_PLATFORMTHEME="qt6ct"
export XDG_CURRENT_DESKTOP=KDE

setopt autocd
setopt beep
setopt notify

# setopt extendedglob
setopt EXTENDED_GLOB NO_BANG_HIST
unsetopt HIST_SUBST_PATTERN

# Permite comentários em comandos interativos
setopt INTERACTIVE_COMMENTS

# Configurações adicionais, se aplicável
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Configurações distcc
export DISTCC_HOSTS=" \
                    192.168.15.10/28,lzo \
                    192.168.5.20/10,lzo \
                    192.168.15.30/8,lzo \
                    100.100.10.10/28,lzo \
                    100.100.10.20/10,lzo \
                    100.100.10.30/8,lzo \
                    localhost/12"

# Configurações específicas para o LLMs (ex: Ollama)
export OMP_NUM_THREADS=28  # Usa todas as 28 threads do Ryzen
export OLLAMA_NUM_GPU=1    # Força uso da RX 7800 XT via ROCm (verifique compatibilidade)
# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/jkyon/.lmstudio/bin"

# Configurações específicas para o GPG
if [ -n "$(tty)" ]; then
    export GPG_TTY=$(tty)
fi

# Ativa o ambiente virtual do ShellGPT
# if [ -d "$HOME/.venvs/shell-gpt/bin" ]; then
#     source "$HOME/.venvs/shell-gpt/bin/activate"
# else
#     echo "ShellGPT não encontrado. Certifique-se de que o ambiente virtual está instalado em ~/.venvs/shell-gpt"
# fi
