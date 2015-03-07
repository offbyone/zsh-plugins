function docker() {
    echo "First use setup of docker..."
    [ -f /usr/local/bin/boot2docker ] && eval `/usr/local/bin/boot2docker shellinit`
    unset -f docker
    docker "$@"
}
