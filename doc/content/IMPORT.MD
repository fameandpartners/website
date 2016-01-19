## Import

Importing is a three step process:

- download from dropbox and clean data
- perform a dry run of the import
- perform the import

Make sure you do this on preproduction and have the team (including the Visual Merchandiser and Product Owner) confirm the data is correct before running on production.

### Prepare
Prepare accepts a path and a url, and downloads a zip file from dropbox, process the file and cleans any extraneous data.

To download a zipped file of a folder's contents from dropbox make sure the url is appended with `?dl=1`


```
# ./script/prepare_import.sh {location} {url}
./script/prepare_import.sh ~ https://www.dropbox.com/sh/ar0b57n8nfnt82s/AADNNbbuOqExZ12voP46Oe07a?dl=1
```

### Dryrun

import_products.sh assumes that the files live in the home (~) directory.

```
./script/import_products.sh dryrun
```

### Import
```
./script/import_products.sh
```
