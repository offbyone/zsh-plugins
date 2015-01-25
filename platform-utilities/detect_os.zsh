os_platform() {
    case `uname -s` in
        Darwin)
            echo "osx"
        ;;
        *)
            echo "linux"
        ;;
    esac
}
