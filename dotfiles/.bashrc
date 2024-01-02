#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="[\u@\h \W]\033[32m\]\$(parse_git_branch)\[\033[00m\] $ "

PATH=$PATH:/opt/google-cloud-sdk/bin:~/.local/bin
source /usr/share/bash-completion/completions/*
source /opt/google-cloud-sdk/completion.bash.inc

alias tf='terraform'
