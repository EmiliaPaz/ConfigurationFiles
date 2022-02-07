# Common commands
alias c='clear'
alias q='exit'
alias ..='cd ..'
alias ..2='cd ../ ..'
alias ..3='cd ../../..'
alias ls='ls -GFh'
alias g='git'
alias limit='ulimit -n 50000' # when too many files are open

# Shortcuts
alias bsh='vim ~/.bash_profile'
alias vimrc='vim ~/.vimrc'
alias gitcfg='vim ~/.gitconfig'

# Terminal prompt
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
PS1_time='\[\e[01;37m\]\t'
PS1_user='\[\e[34m\]\u\[\e[37m\]'
PS1_gitbranch="\[\033[33m\]\$(parse_git_branch)"
PS1_wdir='\[\e[36m\]\w\[\e[34m\]'
PS1_cmd='\$\[\033[00m\]'
PS1="${PS1_time} ${PS1_wdir}${PS1_gitbranch}${PS1_cmd}"
