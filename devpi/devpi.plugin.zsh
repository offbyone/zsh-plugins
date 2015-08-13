# Plugin that, if docker is available AND devpi is available, will set
# the pip environments needed to use it preferentially

__setup_devpi() {
    local _docker_machine=${DOCKER_MACHINE_NAME:-dev}
    local _devpi_container=devpi
    local _running=$(docker inspect --format="{{ .State.Running }}" $_devpi_container 2> /dev/null)
    if [ $? -eq 1 ]; then
        # the container doesn't exist
        return 1
    fi

    if [ "$RUNNING" == "false" ]; then
        # the container isn't running
        return 1
    fi

    # okay, we have this now
    export PIP_INDEX_URL=http://$(docker-machine ip $_docker_machine):3141/root/pypi/+simple/
}

__setup_devpi()
unset -f __setup_devpi
