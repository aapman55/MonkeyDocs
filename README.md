# MonkeyDocs
Documentation/ brain dumps on all kinds off tech topics.

## How to setup environment
Preferably create a separate virtual environment. Then install the dependencies.
```commandline
pip install -r requirements.txt
```

Finally you can startup a local server using
```commandline
mkdocs serve
```
Everytime you make a change to the md content files, the server will detect the change and refresh the
page automatically.

Be aware that before you make the Pull Request, you make sure that there are no build errors and warnings.
Otherwise the Github check will fail. The check is set to `--strict`, so it will also fail warnings.