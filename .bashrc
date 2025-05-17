#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ip='ip -c'
alias grep='grep --color=auto'
alias ll='ls -l'
alias la='ls -la'
alias vi='nvim'
alias r='ranger'
alias SERWER='systemctl start home-adrian-media-SERWER.mount'
alias PROGRAMOWANIE='cd /home/adrian/Insync/IT/PROGRAMOWANIE'
alias mp='mousepad'
alias UPDATE='ansible-playbook /home/adrian/Insync/IT/PROGRAMOWANIE/Ansible/update-playbook.yml --ask-become-pass'
alias p='python'
alias n='nvim'
alias guacamole='docker run -p 8080:8080 -v /home/adrian/guacamole:/config oznu/guacamole'
alias ekranon='xrandr --output DP1-1 --mode 3840x2160 --right-of eDP1 --right-of eDP1 --primary'
alias ekranoff='xrandr --output DP1-1 --auto'

PS1='\[\e[38;5;208m\]\u\[\e[0m\] \[\e[2;3m\]\h\[\e[0m\] \[\e[38;5;39m\]\w\[\e[0m\] '

export HISTSIZE=10000
export HISTFILESIZE=20000
shopt -s histappend
export PROMPT_COMMAND='history -a'

export VISUAL=nvim
export EDITOR=nvim
export PATH=$PATH:/home/$username/CLOUD/IT/PROGRAMOWANIE/Bash/bash_scripts
