#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias tf='terraform'

# Prompt: [user@host dir] (git-branch) $
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="[\u@\h \W]\[\033[32m\]\$(parse_git_branch)\[\033[00m\] $ "

export PATH="$HOME/.local/bin:$PATH"

# Completions (each only if present on this machine)
[ -r /usr/share/bash-completion/bash_completion ] && source /usr/share/bash-completion/bash_completion
for f in /opt/google-cloud-cli/completion.bash.inc /opt/google-cloud-sdk/completion.bash.inc; do
    [ -r "$f" ] && source "$f" && break
done
unset f
