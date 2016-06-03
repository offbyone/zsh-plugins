#!/bin/zsh
function have() {
    which $1 &>/dev/null
}

# GNU utils
have gls && alias ls='gls --color=auto'
have gsed && alias sed=gsed && alias esed='gsed -r'
have grm && alias rm=grm
have gxargs && alias xargs=gxargs
have greadlink && alias readlink=greadlink
