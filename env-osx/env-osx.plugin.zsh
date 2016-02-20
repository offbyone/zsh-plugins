# iterm2 integration

function __osx_plugin_die() {
    echo "${1}"
    exit 1
}

ITERM2_SHELL_INTEG_FILENAME="${HOME}/.iterm2_shell_integration.${SHELL}"

install_iterm2_shell_integration() {
    which printf > /dev/null 2>&1 || __osx_plugin_die "Shell integration requires the printf binary to be in your path."
    local URL="https://iterm2.com/misc/zsh_startup.in"
    local HOME_PREFIX='${HOME}'

    local FILENAME=$ITERM2_SHELL_INTEG_FILENAME
    local RELATIVE_FILENAME="${HOME_PREFIX}/.iterm2_shell_integration.${SHELL}"

    echo "Downloading script from ${URL} and saving it to ${FILENAME}..."
    curl -L "${URL}" > "${FILENAME}" || __osx_plugin_die "Couldn't download script from ${URL}"
    chmod +x "${FILENAME}"
}


iterm2_shell_integration_installed() {
    test -e $ITERM2_SHELL_INTEG_FILENAME
}

load_iterm2_shell_integration() {
    . $ITERM2_SHELL_INTEG_FILENAME
}

if ! iterm2_shell_integration_installed; then
    install_iterm2_shell_integration
fi

if ! iterm2_shell_integration_installed; then
    echo "Unable to install iterm2 shell integration"
else
    load_iterm2_shell_integration
fi
