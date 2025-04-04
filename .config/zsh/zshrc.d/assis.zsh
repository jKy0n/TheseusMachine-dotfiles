# ~/.config/zsh/zshrc.d/assis.zsh

# Assis is a custom Zsh function that leverages artificial intelligence (via Ollama + Mistral-instruct)
# to act as a virtual assistant directly in the terminal, aiding in administrative tasks and system management.

# function assis() {
#   # Coleta de contexto do sistema ANTES do sandbox
#   local system_context=(
#     "Sistema: $(lsb_release -ds) | Kernel: $(uname -r)"
#     "Armazenamento: $(df -h / /home --output=source,avail | tail -n 2 | tr '\n' ' ')"
#     "Logs Recentes: $(journalctl --since "10 min ago" -n 3 --no-pager | grep -E 'error|warning' | tail -n 2)"
#   )

#   # Configuração do sandbox com acesso seletivo
#   bwrap --ro-bind /etc /etc \
#         --ro-bind /var/log /var/log \
#         --ro-bind ~/.config ~/.config \
#         --tmpfs /home \
#         --tmpfs /tmp \
#         --share-net \
#         --unshare-uts \
#         --die-with-parent \
#         ollama run mistral:7b-instruct-v0.3-q4_K_M \
#         "[CONTEXTO] ${(F)system_context}
        
#         Você é o Assis, assistente especialista em Gentoo Linux. Regras:
#         1. Acesso SOMENTE LEITURA aos diretórios:
#            - /etc/*
#            - /var/log/**/*.log
#            - ~/.config
#         2. Formate respostas em markdown técnico
#         3. Traduza termos complexos (PT-BR entre parênteses)
#         4. Priorize comandos não-destrutivos e seguros

#         [PERGUNTA] ${@}" | glow -s dark
# }

function assis() {
  # Caminho absoluto do Ollama (verifique com 'which ollama')
  local OLLAMA_BIN="/usr/bin/ollama"
  
  # Configuração do sandbox com acesso necessário
  bwrap \
    --ro-bind / / \
    --ro-bind $OLLAMA_BIN $OLLAMA_BIN \
    --ro-bind /usr/lib64 /usr/lib64 \
    --tmpfs /tmp \
    --share-net \
    --unshare-uts \
    $OLLAMA_BIN run mistral:7b-instruct-v0.3-q4_K_M \
    "[CONTEXTO] $(lsb_release -d) | Kernel: $(uname -r)
    
    Regras do Assis:
    1. Acesso somente leitura a:
       - /etc/*
       - /var/log/**/*.log
       - ~/.config
    2. Formate respostas em markdown
    3. Traduza termos técnicos (PT-BR)
    
    [PERGUNTA] $@" | glow -s dark
}