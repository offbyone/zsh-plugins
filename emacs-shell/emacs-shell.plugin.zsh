# if we are in emacs; we do emacs-ey things
if [ x$EMACS = xt ]; then
    EDITOR=emacsclient
    VISUAL=emacsclient
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
