#!/usr/bin/env zsh

function install_pythonbrew() {
    curl -kL http://github.com/offbyone/pythonbrew/raw/master/pythonbrew-install | bash
    return $?
}

echo "[Oh My Zsh - pythonbrew] Would you like to install pythonbrew?"
echo "Type Y to install"
read line
if [ "$line" = Y ] || [ "$line" = y ]; then
    install_pythonbrew
    exit $?
else
    echo "Skipping installation. To be asked again, just delete "
    echo "$HOME/.pythonbrew"
    mkdir "$HOME/.pythonbrew"
    exit 1
fi
