# .bashrc

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

