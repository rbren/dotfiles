Copy ~/.ssh/github and ~/.ssh/github.pub from an existing machine

Then run
```bash
chmod 600 ~/.ssh/github
chmod 644 ~/.ssh/github.pub
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/github
cat >> ~/.ssh/config << 'EOF'
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/github
    IdentitiesOnly yes
EOF
chmod 600 ~/.ssh/config
```

Finally
```bash
mkdir ~/git && cd ~/git
git clone ssh://git@github.com/rbren/dotfiles
cd dotfiles
./setup/all.sh
```
