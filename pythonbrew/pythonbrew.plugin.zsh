HERE=$(unset CDPATH; cd `dirname $0`; pwd)
__python_brew_offer_file=$HERE/offer_install.zsh

function ensure_pythonbrew() {

    if [[ -d $HOME/.pythonz ]]; then
        __python_brew_dir=$HOME/.pythonz
        [[ -x $HOME/.pythonz/bin/pythonz ]] && return 0
        return 1
    fi

    if [[ -d $HOME/.pythonbrew ]]; then
        __python_brew_dir=$HOME/.pythonbrew
        [[ -x $HOME/.pythonbrew/bin/pythonbrew ]] && return 0
        return 1
    fi

    /usr/bin/env zsh $__python_brew_offer_file
    return $?
}

if ensure_pythonbrew; then
    append_path PATH $__python_brew_dir/bin
    unset __python_brew_dir
    export PATH
fi

unset __python_brew_offer_file
