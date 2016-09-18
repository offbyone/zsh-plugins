# if we are in emacs; we do emacs-ey things
if [[ ! -z $INSIDE_EMACS ]]; then
    EDITOR=emacsclient
    VISUAL=emacsclient
    PAGER=cat
    export PAGER
else
    # Need OSX vs Posix here
    if [[ `os_platform` == 'osx' ]]; then
        EDITOR=mate
        VISUAL=mate
    else
        EDITOR=emacsclient
        VISUAL=emacsclient
    fi
fi

export EDITOR
export VISUAL
