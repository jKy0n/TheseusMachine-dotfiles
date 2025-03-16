# Plugins específicos para Gentoo Linux

# Autocomplete deve vir primeiro
source /usr/share/zsh/site-functions/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# Autosuggestions vem depois
source /usr/share/zsh/site-functions/zsh-autosuggestions.zsh

# Histórico baseado em substring
source /usr/share/zsh/site-functions/zsh-history-substring-search.zsh

# Syntax highlighting deve ser carregado por último
source /usr/share/zsh/site-functions/zsh-syntax-highlighting.zsh

# Tema do syntax highlighting
source ~/.config/zsh/zsh-syntax-highlighting/themes/catppuccin_macchiato-zsh-syntax-highlighting.zsh


# Configurações para manter caminhos relativos no autocompletar
zstyle ':autocomplete:*' path-completion relative
zstyle ':autocomplete:*' file-suffixes ''
zstyle ':completion:*' path-completion no
zstyle ':completion:*:*:cd:*' ignore-parents parent pwd


autoload -Uz compinit
compinit
setopt COMPLETE_ALIASES

precmd() {
    if ! [[ -n ${(f)functions[_autocomplete_widget]} ]]; then
        # echo "Recarregando zsh-autocomplete..."
        source /usr/share/zsh/site-functions/zsh-autocomplete/zsh-autocomplete.plugin.zsh
    fi
}
