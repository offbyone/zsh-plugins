# Plugin that, if docker is available AND devpi is available, will set
# the pip environments needed to use it preferentially

__setup_devpi() {
    if launchctl list net.devpi 2>/dev/null >/dev/null; then
        export PIP_INDEX_URL=http://localhost:3141/root/pypi/+simple/
    else
        local _devpi_container=devpi
        local _running=$(docker inspect --format="{{ .State.Running }}" $_devpi_container 2> /dev/null)
        if [[ "$_running" != "true" ]]; then
            # the container isn't running
            return 1
        fi

        # okay, we have this now
        export PIP_INDEX_URL=http://localhost:3141/root/pypi/+simple/
    fi
}

__setup_devpi
unset -f __setup_devpi
