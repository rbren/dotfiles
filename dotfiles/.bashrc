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

