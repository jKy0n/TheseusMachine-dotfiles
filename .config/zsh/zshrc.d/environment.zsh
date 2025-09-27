# Variáveis de ambiente gerais

export EDITOR=nvim
export VISUAL=nvim
export SYSTEMD_EDITOR=nvim

export QT_QPA_PLATFORMTHEME="qt6ct"

setopt autocd
setopt beep
setopt notify

# setopt extendedglob
setopt EXTENDED_GLOB NO_BANG_HIST
unsetopt HIST_SUBST_PATTERN

# Configurações adicionais, se aplicável
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

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