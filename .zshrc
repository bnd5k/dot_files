# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


# CS App aliases
# From groupon app
alias teardowncs='script/runner -e test ../orders_integration/teardown_orders_db.rb'
alias seedcs='script/runner -e test ../orders_integration/seed_orders_db.rb'
alias rebuildcs="echo 'Tearing down...' && teardowncs && echo 'Seeding...' && seedcs"
alias gprom="git pull --rebase origin master"

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
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=/Users/geoff/.rvm/gems/ree-1.8.7-2011.03@groupon/bin:/Users/geoff/.rvm/gems/ree-1.8.7-2011.03@global/bin:/Users/geoff/.rvm/rubies/ree-1.8.7-2011.03/bin:/Users/geoff/.rvm/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin
if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then source "$HOME/.rvm/scripts/rvm" ; fi 


# Node.js
export NODE_PATH=/usr/local/lib/node_modules

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
PATH=$PATH:$HOME/programs