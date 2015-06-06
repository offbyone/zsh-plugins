if hash boot2docker 2>/dev/null; then
    index_url() {
        if (eval `boot2docker shellinit`; docker inspect devpi >/dev/null 2>&1); then
            export PIP_INDEX_URL=http://$(boot2docker ip):3141/root/pypi/+simple/
            echo $PIP_INDEX_URL
        fi
    }
fi
