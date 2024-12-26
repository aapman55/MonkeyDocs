# Useful Git commands

## Get current branch name

```commandline
git rev-parse --abbrev-ref HEAD
```
## git-rev-list

The `rev-list` command lists commit objects in reverse chronological order.
For the full documentation please see: https://git-scm.com/docs/git-rev-list.

Syntax:
```commandline
git rev-list [<options>] <commit>…​ [--] [<path>…​]
```

Some handy options to consider:
* `--count` counts the number of commits.
* `--format` allows for formatting the output.
* `--merges` only show merge commits.

In the next subsections we will give some examples on handy use-cases.

### Amount of commits behind

```commandline
git rev-list --count <current branch>..<target branch>
```

### Amount of commits ahead

```commandline
git rev-list --count <target branch>..<current branch>
```

### Get list of merge commits
Let's say we have a `development` branch in which all commits are collected before going
to production. Once we go to production the changes will be merged into the `master` branch.
If you want to have a quick overview of which Pull Request are included you can filter on 
the word `Merged` in the commit message. As this is the default name the commit gets when 
completing the Pull Request with a merge or semi-linear merge.

```commandline
git rev-list --format="%Bauthor: %an" --merges master..development | grep -e "Merged PR" -e "author: "
```

## Changed files

```commandline
git diff <target branch> --name-only
```