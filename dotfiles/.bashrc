#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# GCP Autocompletion
source /opt/google-cloud-sdk/completion.bash.inc

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

export PATH=$PATH:/opt/google-cloud-sdk/bin:~/.local/bin


alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
export PS1="\u@\h \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "
[ -r /home/gary/.byobu/prompt ] && . /home/gary/.byobu/prompt   #byobu-prompt#
