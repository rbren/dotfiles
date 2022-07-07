# .bashrc

# https://stackoverflow.com/questions/12440287/scp-doesnt-work-when-echo-in-bashrc
# skip bashrc if not interactive
if [ -z "$PS1" ]; then
    return
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

for FN in $HOME/bashrc.d/*.sh ; do
    echo "sourcing $FN"
    source "$FN"
done


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/rbren/miniforge/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/rbren/miniforge/etc/profile.d/conda.sh" ]; then
        . "/home/rbren/miniforge/etc/profile.d/conda.sh"
    else
        export PATH="/home/rbren/miniforge/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

