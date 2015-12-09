#!/usr/bin/env zsh
setopt prompt_subst
autoload -Uz vcs_info

export VIRTUAL_ENV_DISABLE_PROMPT=yes

# -*- shell-script -*-
function collapse_pwd {
    echo $(pwd | sed -e "s,^$HOME,~,")
}

function hg_root() {
    hg root 2>/dev/null
}

function git_root() {
    git rev-parse --show-toplevel 2>/dev/null
}

function p4_root() {
    p4 info 2>/dev/null | awk '/Client root: / {print $3}' 2>/dev/null
}

function svn_root() {
    svn info >/dev/null 2>&1 && echo $(pwd)
}

function bzr_root {
    root=$(bzr info 2>/dev/null | grep 'branch root:' | sed -e 's/^.*branch root: //')
    if [[ ${root}xxx != xxx ]]; then
        root=$(unset CDPATH; cd $root; pwd)
        echo $root
    fi
}

_VCS_TYPES=NONE

function vcs_types() {
    local vcs_type_list=""

    if [ "$_VCS_TYPES" != NONE ]; then
        echo "$_VCS_TYPES"
        return
    fi

    if [[ -f $HOME/.zsh-vcs-types ]]; then
        for t in `cat $HOME/.zsh-vcs-types`; do
            vcs_type_list="$vcs_type_list $t"
        done
        _VCS_TYPES="$vcs_type_list"
    else
        _VCS_TYPES="hg git svn bzr p4"
    fi

    echo "$_VCS_TYPES"
}

function vcs_type() {
    typeset -A vcs_paths
    local _vcs_types="$(vcs_types)"
    _vcs_types=(${(s/ /)_vcs_types})
    for vcs_type in $_vcs_types; do
        cmd=${vcs_type}_root
        vcs_paths[$vcs_type]=$($cmd)
    done

    local answer=none
    local max=0

    for key in $_vcs_types; do
        cur=${#vcs_paths[$key]};
        if (( cur == 0 )); then
            continue
        fi

        if (( cur > max )); then
            max=$cur;
            answer=$key;
        fi;
    done

    echo $answer
}

typeset -A -g prompt_char_map
prompt_char_map[git]='±'
prompt_char_map[hg]='☿'
prompt_char_map[p4]='☉'
prompt_char_map[svn]='ƾ'
prompt_char_map[bzr]='β'
prompt_char_map[default]='$'

function prompt_char {
    local _vcs=$(vcs_type)
    case $_vcs in
        git|hg|svn|bzr|p4)
            echo $prompt_char_map[$_vcs]
            ;;
        *)
            echo $prompt_char_map[default]
            ;;
    esac
}

function virtualenv_info {
    if [ $VIRTUAL_ENV_NAME ]; then
        echo -n "(${VIRTUAL_ENV_NAME}) "
    elif [ $VIRTUAL_ENV ]; then
        echo -n '('`basename $VIRTUAL_ENV`') '
    fi
}

function get_prompt_host_color() {
    env_name=${1:-`get_env_name`}
    case $env_name in
        home.personal)
            color=$fg[green]
            ;;
        work.personal)
            color=$fg[cyan]
            ;;
        work.test)
            color=$fg[green]
            ;;
        work.qa)
            color=$fg[yellow]
            ;;
        work.production)
            color=$fg_bold[red]
            ;;
        *)
            color=$fg[red]
            ;;
    esac
    echo $color
}

function get_prompt_text_color() {
    env_name=$1
    echo $fg_bold[white]
}

function get_prompt_user_color() {
    env_name=${1:-`get_env_name`}
    case $env_name in
        home.personal | work.personal)
            color=$fg[cyan]
            ;;
        work.test)
            color=$fg[green]
            ;;
        work.qa)
            color=$fg[yellow]
            ;;
        work.production)
            color=$fg[red]
            ;;
        *)
            color=$fg[red]
            ;;
    esac
    [ "$USER" = "root" ] && color=$fg[black]$bg[red]
    echo $color
}

zstyle ':vcs_info:*' enable `vcs_types`

zstyle ':vcs_info:(hg*|git*|bzr*):*' get-revision true
zstyle ':vcs_info:(hg*|git*|bzr*):*' check-for-changes true

# rev+changes branch misc
zstyle ':vcs_info:(git*|hg*)' stagedstr "○"
zstyle ':vcs_info:(git*|hg*)' unstagedstr "⚡"
zstyle ':vcs_info:hg*' formats "[%i%u %b%m]"
zstyle ':vcs_info:hg*' actionformats "(%{$fg_bold[red]%}%a%{$reset_color%})[%i%u %b%m]"

# hash changes branch misc
zstyle ':vcs_info:(git*|bzr*)' formats "[%{$fg[yellow]%}%12.12i%{$reset_color%} %u %{$fg[magenta]%}%b%{$reset_color%}%m]"
zstyle ':vcs_info:(git*|bzr*)' actionformats "(%a)[%{$fg[yellow]%}%12.12i%{$reset_color%} %u %{$fg[magenta]%}%b%{$reset_color%}%m]"

zstyle ':vcs_info:git*+set-message:*' hooks git-st git-stash

zstyle ':vcs_info:hg*:netbeans' use-simple true

zstyle ':vcs_info:hg*:*' get-bookmarks true

zstyle ':vcs_info:hg*:*' get-mq true
zstyle ':vcs_info:hg*:*' get-unapplied true
zstyle ':vcs_info:hg*:*' patch-format " mq(%g):%{$fg[green]%}%n%{$reset_color%}/%{$fg_bold[blue]%}%c%{$reset_color%} %{$fg[green]%}%p%{$reset_color%}"
zstyle ':vcs_info:hg*:*' nopatch-format ""

zstyle ':vcs_info:hg*:*' unstagedstr " ?"
zstyle ':vcs_info:hg*:*' hgrevformat "%{$fg[yellow]%}%r%{$reset_color%}" # only show local rev.
zstyle ':vcs_info:hg*:*' branchformat "%{$fg[magenta]%}%b%{$reset_color%}" # only show branch

# Show remote ref name and number of commits ahead-of or behind
function +vi-git-st() {
    local ahead behind remote
    local -a gitstatus

    # Are we on a remote-tracking branch?
    remote=${$(git rev-parse --verify ${hook_com[branch]}@{upstream} \
        --symbolic-full-name 2>/dev/null)/refs\/remotes\/}

    if [[ -n ${remote} ]] ; then
        # for git prior to 1.7
        # ahead=$(git rev-list origin/${hook_com[branch]}..HEAD | wc -l)
        ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l | tr -s ' ')
        (( $ahead )) && gitstatus+=( " ${c3}+${ahead}${c2}" )

        # for git prior to 1.7
        # behind=$(git rev-list HEAD..origin/${hook_com[branch]} | wc -l)
        behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l | tr -s ' ')
        (( $behind )) && gitstatus+=( " ${c4}-${behind}${c2}" )

        hook_com[branch]="${hook_com[branch]} [${remote}${(j:/:)gitstatus}]"
    fi
}

# Show count of stashed changes
function +vi-git-stash() {
    local -a stashes

    if [[ -s ${hook_com[base]}/.git/refs/stash ]] ; then
        stashes=$(git stash list 2>/dev/null | wc -l)
        hook_com[misc]+=" (${stashes} stashed)"
    fi
}

function vcs_info_local_only() {
    unset vcs_info_msg_0_
    if is_local_fs; then
        vcs_info
    elif [ "$ZSH_FORCE_VCS_PROMPT" = 1 ]; then
        vcs_info
    fi
}

precmd () { vcs_info_local_only }
PROMPT='
%{$(get_prompt_user_color)%}%n%{$reset_color%} at %{$(get_prompt_host_color)%}%m%{$reset_color%} in %{$fg_bold[green]%}%~%{$reset_color%} ${vcs_info_msg_0_}
$(virtualenv_info)$(prompt_char) '
