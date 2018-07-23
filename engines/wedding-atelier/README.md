# Wedding Atelier
## Usage:
First, make sure you have Postgres installed and running.
Then, run a series of database commands from APP root
```
script/db # Select option 2
bundle exec rake db:migrate wedding_atelier:populate_products
```

Then, if you are running this app as an Engine, you must activate it, run `rails console` and :
```
Features.activate(:wedding_atelier)
```

## Images uploading

All images for the dresses live in dropbox, so if you want to upload them to amazon, first you need to sync with dropbox, ask for access to the shared folder.

Once you get the access and assets are synced you can start the upload process, this happening using `aws cli`, you can install it by running `pip install awscli`

The folder structure of the images should be the following (in S3)

** Be careful with folder names, they should be all lowercase and filenames are all uppercase **


### Real images (with models)

`"#{bucket_name}/wedding_atelier/dresses/350x500/"`
`"#{bucket_name}/wedding_atelier/dresses/1440x1310/"`


### Upload using cli

Basic example of uploading images for grey thumbnails.

`cd ~/Dropbox/3dRenders/D1-12212/03_CustomisationCombo/180x260/grey/`
`aws s3 sync . s3://fandp-web-qa1/wedding_atelier/dresses/180x260/grey/`

and that's it let it do it's job.
