# Useful Git commands

## Get current branch name

```commandline
git rev-parse --abbrev-ref HEAD
```

## Amount of commits behind

```commandline
git rev-list --count <current branch>..<target branch>
```

## Amount of commits ahead

```commandline
git rev-list --count <target branch>..<current branch>
```

## Changed files

```commandline
git diff <target branch> --name-only
```