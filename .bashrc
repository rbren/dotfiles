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

if [ -f /home/ubuntu/.cuddlefish/config ]; then
        . /home/ubuntu/.cuddlefish/config
fi

for FN in $HOME/bashrc.d/*.sh ; do
    source "$FN"
done

if [ -f ~/.local-bashrc ]; then
  source ~/.local-bashrc
fi

