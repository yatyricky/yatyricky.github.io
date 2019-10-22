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
git config --global alias.ll "log --pretty=format:'%h - %an, %ar : %s'"
git config --global alias.st "status"
git config --global alias.sh "stash save temp"
git config --global alias.ush "stash pop stash@{0}"
git config --global alias.rb "pull --rebase"
```