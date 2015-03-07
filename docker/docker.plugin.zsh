function docker() {
    # first try docker-machine
    if hash docker-machine 2>/dev/null; then
        cmd=$(which docker-machine)
        echo "Using docker-machine from ${cmd}"
        unset -f docker
        if (($+DOCKER_MACHINE_NAME)); then
            eval `$cmd env $DOCKER_MACHINE_NAME`
        else
            eval `$cmd env boot2docker`
        fi
        docker "$@"
    elif hash boot2docker 2>/dev/null; then
        cmd=$(which boot2docker)
        echo "Using boot2docker from ${cmd}"
        unset -f docker
        eval `${cmd} shellinit`
        docker "$@"
    elif hash docker 2>/dev/null; then
        echo "Using docker from $(which docker)"
        unset -f docker
        docker "$@"
    else
        echo "No docker support installed"
    fi
}
