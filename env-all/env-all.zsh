append_path PATH $HOME/git-scripts
append_path PATH $HOME/bin
append_path PATH $HOME/local/bin
append_path PATH $HOME/.local/bin

# add path entries for git extensions
for ext in $HOME/extensions/git*; do
    if [ -d $ext/bin ]; then
        ext=$ext/bin
    elif [ -d $ext/lib ]; then # no bin, but lib? Sure, we'll try that...
        ext=$ext/lib
    fi
    append_path PATH $ext
done

# There are few, if any circumstances where I won't want this in my shell.
setopt extendedglob
