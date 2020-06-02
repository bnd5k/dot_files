eval "$(rbenv init -)"
export PS1='$ '
export PATH="/usr/local/bin:/usr/sbin:~/bin:/usr/local/sbin:/usr/local/bin/postgres:$PATH"

alias sz='source ~/.zshrc'
alias g="git "
alias br="branch"
alias aa="add ."
alias st="status "
alias ci="commit"
alias cim="commit -m"
alias co="checkout "
alias please="push --force-with-lease"

alias b="bundle"
alias be="bundle exec"
alias bu="bundle update "
alias rspec="be rspec"
alias rake="be rake"
alias cucumber="be cucumber"
alias rails="be rails"

alias dc="docker-compose "

export EDITOR=vi

# Added these when setting up ionic.
# Create a JAVA_HOME variable, determined dynamically
export JAVA_HOME=$(/usr/libexec/java_home)
# Add that to the global PATH variable
export PATH=${JAVA_HOME}/bin:$PATH
# Set Android_HOME
export ANDROID_HOME=~/Library/Android/sdk/
# Add the Android SDK to the ANDROID_HOME variable
export PATH=$ANDROID_HOME/platform-tools:$PATH
export PATH=$ANDROID_HOME/tools:$PATH
#Set GRADLE_HOME
export GRADLE_HOME=/Library/gradle/gradle-3.2
export PATH=$PATH:$GRADLE_HOME/bin

export ANDROID_SDK_ROOT="/usr/local/share/android-sdk"

export PATH="$(yarn global bin):$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source ~/.zsh/functions/auto_switch_node_version.zsh


