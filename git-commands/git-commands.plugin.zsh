# Create new local branch based off pull request X.
function pr-branch() {
    git fetch origin pull/$1/head:$1-int
    git checkout $1-int
    [[ $2 == "nomerge" ]] || git merge master
}
