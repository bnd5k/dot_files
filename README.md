# Overview
This repo contains all of my dot files.  They're located in the home directory to take advantage of the [homesick gem](https://github.com/technicalpickles/homesick).
Also, I'm using Tim Pope's [vim-pathogen plugin](http://github.com/tpope/vim-pathogen), which allows the easy organization of plugins under the /bundle directory.  Git submodules allow me to easily update to the latest plugins.

# Setup
1. Once you have homesick installed, then pull down these files by using the following commands.

```homesick clone  git@github.com:bnd5k/dot_files.git.

```homesick symlink dot_files

2. Sometimes, if you already have a .vim directory, the dot files get stored in a .vim directory inside your preexisting .vim directory.  If you that going on, then run these commands.  (BTW if you get and error abour colors when you startup vim, then you're
   experiencing the problem).

```
    cp -rf .vim/.vim/* .vim/
    rm -rf /.vim/.vim
```
3. Set your email address in the git config file.  At the command line, run these comands. (If you don't, you'll be committing work as Ben Downey.)

  ```git config --global user.name "John Doe"

  ```git config --global user.email johndoe@example.com

