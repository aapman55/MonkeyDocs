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
If you want to have a quick overview of which Pull Request are included you can use the 
option `--merges`.

```commandline
git rev-list --format="%Bauthor: %an" --merges master..development
```

This however, will also print out the commit hash, related work items and the comment of the 
commit. If we just wanted a short overview of what the title was and who merged it, we can
pass the output to `grep` and look for `Merged PR`, as that is the default commit title when
completing a Pull Request in Azure DevOps. If we also want to include the author, we can add
that as well.

More on [grep](grep.md).

```commandline
git rev-list --format="%Bauthor: %an" --merges master..development | grep -e "Merged PR" -e "author: "
```

## Changed files

```commandline
git diff <target branch> --name-only
```