Git global config location: `~/.gitconfig`

``` sh
# open before, ~1 is important
git checkout <Commit>~1 <Path to file>

# force push
git push origin <your_branch_name> --force

# remove cached
git rm -r --cached .

# This will destroy any local modifications.
# Don't do it if you have uncommitted work you want to keep.
git reset --hard 0d1d7fc32

# aliases
git config --global alias.rb "pull --rebase"
# unset aliases
git config --global --unset alias.rb

# local ignore path
.git/info/exclude

# assume file unchanged
git update-index --assume-unchanged path
git update-index --no-assume-unchanged path

# list files marked as assume unchanged
# assume unchanged files first flag is lower case
git ls-files -v | grep '^[[:lower:]]'

# Amend commit message. change the most recent commit message
git commit --amend
```

```
st = status
sh = stash save temp
ush = stash pop stash@{0}
ll = log --pretty=format:'%h - %an, %ar : %s'
rb = pull --rebase
ds = checkout -- .
cm = commit -m
am = commit -am
ck = checkout
```