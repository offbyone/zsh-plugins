append_path PATH $HOME/git-scripts
append_path PATH $HOME/bin
append_path PATH $HOME/local/bin
append_path PATH $HOME/.local/bin

# add path entries for git extensions
for ext in $HOME/extensions/git*; do
    if [ -d $ext/bin ]; then
        ext=$ext/bin
    fi
    append_path PATH $ext
done
