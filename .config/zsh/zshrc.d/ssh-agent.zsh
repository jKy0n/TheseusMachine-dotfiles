# Initializa o ssh-agent e o keychain


# export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

# Inicializa o ssh-agent
eval "$(ssh-agent -s)" > /dev/null

# Inicializa o keychain
eval $(keychain --eval --quiet theseusMachine_to_github)