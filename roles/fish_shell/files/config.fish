# Environment setup
if type -q direnv
    direnv hook fish | source
end

# Java/Gradle optimization
set -gx GRADLE_OPTS "-Xmx2048m -Dorg.gradle.daemon=true"
set -gx MAVEN_OPTS "-Xmx2048m"

# SDKMAN
set -gx SDKMAN_DIR "$HOME/.sdkman"
if test -f "$SDKMAN_DIR/bin/sdkman-init.sh"
    # Fish doesn't support SDKMAN directly, use bass if available
    if type -q bass
        bass source "$SDKMAN_DIR/bin/sdkman-init.sh"
    end
end

# Set JAVA_HOME (from SDKMAN)
if test -d "$HOME/.sdkman/candidates/java/current"
    set -gx JAVA_HOME "$HOME/.sdkman/candidates/java/current"
end

# PATH additions
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.opencode/bin
fish_add_path $HOME/Applications

# fzf configuration
set -gx FZF_DEFAULT_OPTS '--height 40% --layout=reverse --border'
set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"

# Initialize fzf if available
if type -q fzf
    fzf --fish | source
end

# LS Aliases
alias ls='lsd'
alias l='ls -lha'
alias la='ls -lhA'
alias ll='ls -lAFh'
alias lla='lsd -la'
alias lsa='ls -lha'
alias lt='lsd --tree'

# General Aliases
alias c=clear
alias v=nvim
alias vi=nvim
alias vim=nvim

# Build Aliases
alias mcb='mvn clean build'
alias gcb='./gradlew clean build'
alias m='make'

# System Aliases
alias tg='topgrade'
alias dcu='docker-compose up'

# GitHub Copilot Aliases
alias copilot='gh copilot'
alias gcs='gh copilot suggest'
alias gce='gh copilot explain'

# Git Aliases
alias gc='git commit'
alias gs='git status'
alias gp='git push'
alias gl='git pull'
alias gco='git checkout'
alias gd='git diff'
alias gb='git branch'
alias ga='git add'
alias glo='git log --oneline --decorate --color'

# Kubernetes Aliases
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kgd='kubectl get deployments'
alias kl='kubectl logs'
alias kx='kubectl exec -it'
alias kctx='kubectl config use-context'
alias kns='kubectl config set-context --current --namespace'

# JSON/YAML Aliases
alias jpretty='jq .'
alias ymlv='yq eval'

# NPM Aliases
alias ni='npm install'
alias nid='npm install --save-dev'
alias nig='npm install -g'
alias nr='npm run'
alias ns='npm start'
alias nt='npm test'
alias nb='npm run build'
alias spot='./gradlew spotlessApply'

# Utility Aliases
alias lad=lazydocker

# NVM configuration for Fish
set -gx NVM_DIR /home/johan/.nvm

# Load nvm via bass (if available)
if type -q bass
    function nvm
        bass source /home/johan/.nvm/nvm.sh --no-use ';' nvm $argv
    end
end

# Add nvm's default node to PATH
if test -d /home/johan/.nvm/versions/node
    set -gx PATH /home/johan/.nvm/versions/node/(ls /home/johan/.nvm/versions/node | tail -1)/bin $PATH
end
