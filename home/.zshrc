# Lines configured by zsh-newuser-install
HISTFILE=~/.bash_history
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob notify
unsetopt appendhistory nomatch
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/Users/gmassanek/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall




# PROMPT

# Initialize colors.
autoload -U colors
colors
 
# Allow for functions in the prompt.
setopt PROMPT_SUBST
 
# Autoload zsh functions.
fpath=(~/.zsh/functions $fpath)
autoload -U ~/.zsh/functions/*(:t)
 
# Enable auto-execution of functions.
typeset -ga preexec_functions
typeset -ga precmd_functions
typeset -ga chpwd_functions
 
# Append git functions needed for prompt.
preexec_functions+='preexec_update_git_vars'
precmd_functions+='precmd_update_git_vars'
chpwd_functions+='chpwd_update_git_vars'
 
# Set the prompt.
PROMPT=$'%{${fg[cyan]}%}%B%~%b$(prompt_git_info)%{${fg[default]}%} '


# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


# CS App aliases
# From groupon app
#
#
alias teardowncs="echo 'Tearing down...' && cd orders && script/runner -e test ../orders_integration/teardown_orders_db.rb && cd .. && cd groupon-web && script/runner -e test ../orders_integration/teardown_orders_db.rb && cd .."
alias seed_groupon_web="echo 'Seeding groupon-web...' && cd groupon-web && script/runner -e test ../orders_integration/seed_groupon_web_db.rb && cd .."
alias seed_orders="echo 'Seeding orders...' && cd orders && script/runner -e test ../orders_integration/seed_orders_db.rb && cd .."
alias seedcs="seed_groupon_web && seed_orders"

alias rebuildcs="teardowncs && echo 'Seeding...' && seedcs"
alias gprom="git pull --rebase origin master"
alias cs='cd ~/code/cs-groupon'
alias gp='cd ~/code/groupon'

function git_remote_url() {
# DOES NOT WORK FOR HTTPS, ONLY git@github.com:username/repo.git
git config --get remote.origin.url | sed 's/git@//' | sed 's/github/https:\/\/github/' | sed 's/com:/com\//' | sed 's/\.git//'
}

function git_current_branch_name() {
  git symbolic-ref HEAD | sed 's/refs\/heads\///'
}

function git_push_open() {
  branch_name=$1
  if [ -z $branch_name ]; then
    branch_name=`git_current_branch_name`
  fi

  git_repo_url=`git_remote_url`
  pull_path="/pull/new/"
  echo $git_repo_url$pull_path$branch_name
  git push origin HEAD:$branch_name && open $git_repo_url$pull_path$branch_name
}
alias gpush="git_push_open"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
#plugins=(git)

#source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=/Users/geoff/.rvm/gems/ree-1.8.7-2011.03@groupon/bin:/Users/geoff/.rvm/gems/ree-1.8.7-2011.03@global/bin:/Users/geoff/.rvm/rubies/ree-1.8.7-2011.03/bin:/Users/geoff/.rvm/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin
if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then source "$HOME/.rvm/scripts/rvm" ; fi 


# Node.js
export NODE_PATH=/usr/local/lib/node_modules

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
PATH=$PATH:$HOME/programs
