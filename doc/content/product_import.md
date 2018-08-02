## Import

Importing is a three step process:

- download from Dropbox and clean data
- perform a dry run of the import
- perform the import

Make sure you do this on staging and have the team (including the Visual Merchandiser and Product Owner) confirm the data is correct before running on production.

### Prepare

Prepare accepts a path and a url, and downloads a zip file from Dropbox, process the file and cleans any extraneous data.

To download a zipped file of a folder's contents from Dropbox make sure the url is appended with `?dl=1`


```
# ./script/prepare_import.sh [location] {url}
./script/prepare_import.sh ~ https://www.dropbox.com/sh/ar0b57n8nfnt82s/AADNNbbuOqExZ12voP46Oe07a?dl=1
./script/prepare_import.sh https://www.dropbox.com/sh/ar0b57n8nfnt82s/AADNNbbuOqExZ12voP46Oe07a?dl=1
```

### Dryrun

import_products.sh assumes that the files live in the home (~) directory.

```
./script/import_products.sh dryrun
```

> You can set the `CONTENT_DIRECTORY_TARGET` env variable to ease up local testing.

```shell
CONTENT_DIRECTORY_TARGET=/Users/tobyhede/document/fame/ProductUpload ./script/import_products.sh dryrun
```

### Import

When running the actual import script, make sure that:

- add the `MARK_NEW_THIS_WEEK` env variable as "true/false"
- New product spreadsheet is inside the `import` folder. (default: `/home/deploy/import/content/import`)

```
MARK_NEW_THIS_WEEK=false ./script/import_products.sh
```

## Importing Images Only

> Remember: you should always run importation scripts on worker machines, since they exist for batch processing.

Sometimes, we're asked to only import images and associate new colors for products.

To do it, you should follow these steps:

- Download from Dropbox and clean data (as explained before)
- Run image importing rakes separately:

```bash
# At the current app folder (e.g. `cdcur` command)

# You can use `nohup`

LOCATION="/home/app_user/import/content/extract" nohup bundle exec rake import:product:images > log/products_import.log &
LOCATION="/home/app_user/import/content/extract" nohup bundle exec rake import:customization:images > log/customizations_import.log &
LOCATION="/home/app_user/import/content/extract" nohup bundle exec rake import:moodboard:images > log/moodboards_import.log &
LOCATION="/home/app_user/import/content/extract" nohup bundle exec rake import:song:images > log/songs_import.log &

# Or `screen`

screen -d -m bash -c 'LOCATION="/home/app_user/import/content/extract" bundle exec rake import:product:images'
screen -d -m bash -c 'LOCATION="/home/app_user/import/content/extract" bundle exec rake import:customization:images'
screen -d -m bash -c 'LOCATION="/home/app_user/import/content/extract" bundle exec rake import:moodboard:images'
screen -d -m bash -c 'LOCATION="/home/app_user/import/content/extract" bundle exec rake import:song:images'
```

These commands will execute Rake tasks in parallel while having their outputs registered on the `log/` folder

## Importing Colors

After uploading new images, it's common to update product colors.

To do it:

- Download from Dropbox and clean data (as explained before)
- Run the `import:data_reshoot` rake task, replacing the `FILE_PATH` with a proper spreadsheet path:

```bash
# At the current app folder (e.g. `cdcur` command)

FILE_PATH="/home/app_user/import/content/extract/NAME-OF-THE-SPREADSHEET.xlsx" bundle exec rake import:data_reshoot
```

This rake will go through the product spreadsheet, creating/updating its product colors accordingly. 
