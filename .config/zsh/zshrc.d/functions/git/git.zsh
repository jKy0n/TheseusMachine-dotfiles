#
#        Title:      git.zsh
#        Brief:
#        Path:       /home/jkyon/.config/zsh/zshrc.d/functions/git/git.zsh
#        Author:     John Kennedy a.k.a. jKyon
#        Created:    2026-02-23
#        Updated:    2026-06-22
#        Notes:
#


#------------------------------------------------------------------------------
# Configuração do repositório compartilhado de scripts
#------------------------------------------------------------------------------

typeset -g GIT_SYNC_REPO="$HOME/ShellScript"
typeset -g GIT_SYNC_REMOTE_REPO="\$HOME/ShellScript"

typeset -ga GIT_SYNC_HOSTS=(
    theseusmachine
    viamar-pc
    crisnote
    builder
)

#------------------------------------------------------------------------------
# git-cp: Realiza 'git commit' e 'git push' em um único comando.
#------------------------------------------------------------------------------
git-cp() {
    if [[ -z "$1" ]]; then
        print -P "%F{red}❌ Erro:%f Faltou a mensagem de commit."
        print "Uso correto: git-cp \"sua mensagem\""
        return 1
    fi

    git commit -am "$*" && git push
}

#------------------------------------------------------------------------------
# git-cp-sync: Commit + push + sincroniza os outros PCs.
#------------------------------------------------------------------------------
git-cp-sync() {
    git-cp "$@" && git-sync
}

#------------------------------------------------------------------------------
# git-status: Faz pull no repo atual e mostra status local.
#------------------------------------------------------------------------------
git-status() {
    local repo="${1:-$GIT_SYNC_REPO}"

    print -P "%F{cyan}🔄 Atualizando:%f $repo"

    git -C "$repo" pull --ff-only || return 1

    print
    git -C "$repo" status -sb
}

#------------------------------------------------------------------------------
# _git-sync-remote: Helper interno para atualizar um host remoto.
#------------------------------------------------------------------------------
_git-sync-remote() {
    local host="$1"

    ssh -o BatchMode=yes -o ConnectTimeout=5 "$host" \
        "cd $GIT_SYNC_REMOTE_REPO && git pull --ff-only"
}

#------------------------------------------------------------------------------
# _git-status-remote: Helper interno para atualizar e ver status remoto.
#------------------------------------------------------------------------------
_git-status-remote() {
    local host="$1"

    ssh -o BatchMode=yes -o ConnectTimeout=5 "$host" \
        "cd $GIT_SYNC_REMOTE_REPO && git pull --ff-only --quiet && git status -sb"
}

#------------------------------------------------------------------------------
# git-sync: Sincroniza o repositório de scripts em todos os PCs via SSH.
#------------------------------------------------------------------------------
git-sync() {
    local host
    local failed=0

    for host in "${GIT_SYNC_HOSTS[@]}"; do
        print
        print -P "%F{blue}🔄 Atualizando $host...%f"

        if _git-sync-remote "$host"; then
            print -P "%F{green}✅ $host atualizado%f"
        else
            print -P "%F{red}❌ $host falhou%f"
            failed=1
        fi
    done

    return "$failed"
}

#------------------------------------------------------------------------------
# git-status-all: Faz pull e mostra status do repo de scripts em todos os PCs.
#------------------------------------------------------------------------------
git-status-all() {
    local host
    local failed=0

    for host in "${GIT_SYNC_HOSTS[@]}"; do
        print
        print -P "%F{blue}🖥️  $host%f"

        if _git-status-remote "$host"; then
            true
        else
            print -P "%F{red}❌ $host falhou%f"
            failed=1
        fi
    done

    return "$failed"
}