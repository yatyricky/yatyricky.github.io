``` sh
# local ignore path
.git/info/exclude

# Git global config path:
`~/.gitconfig`

# Line Engdings
git config --global core.autocrlf false
git config --global core.eol lf

# Text Search
git grep -w -e "GetComponent" -- "client/Assets"

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

# assume file unchanged
git update-index --assume-unchanged path
git update-index --no-assume-unchanged path

# list files marked as assume unchanged
# assume unchanged files first flag is lower case
git ls-files -v | grep '^[[:lower:]]'

# Amend commit message. change the most recent commit message
git commit --amend

# proxy
git config --global http.proxy 'socks5://127.0.0.1:10808'
git config --global https.proxy 'socks5://127.0.0.1:10808'

# gitk find history in all branches
gitk --all --date-order -- <file path>

# git log file beyond renamed
git log --follow --pretty=oneline path/to/file

# prune tags
git fetch --prune origin "+refs/tags/*:refs/tags/*"
# delete tag
git tag -d tagname
git push origin :refs/tags/tagname
# add tag
git tag tagname
# push tag
git push origin tagname

# delete branch
git push -d <remote_name> <branch_name>
git branch -d <branch_name>

# export all history of file
for sha in `git rev-list HEAD -- protos/user.proto`; do
    git show ${sha}:protos/user.proto > ./exportfolder/user_${sha}.proto
done
```

```
[core]
	autocrlf = false
	eol = lf
[alias]
	aa = add -A
	st = status
	sh = stash save temp
	ush = stash pop stash@{0}
	dsh = stash clear
	ll = log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) %C(bold green)(%ar)%C(reset) %C(cyan)%an%C(reset) %C(white)%s%C(reset)%C(bold yellow)%d%C(reset)' --all
	rb = pull --rebase
	ds = checkout -- .
	cm = commit -m
	ck = checkout
	rs = reset --
	cf = clean -f
```
