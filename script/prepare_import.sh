
function prepare
{
  SOURCE_FILE=$1
  echo $SOURCE_FILE
  rm -R import
  mkdir import
  mkdir -p 'import/content'
  mkdir -p 'import/log'
  wget -O 'import/content/import.zip' $SOURCE_FILE
  unzip -x -LL 'import/content/import.zip' -d 'import/content/import'
  rm -R import/content/import/__macosx/
  rm -R import/content/import/cancelled-*
}

function import {
  cd /data/fame_and_partners/current
  ./script/import_products.sh dryrun
  ./script/import_products.sh
}

prepare $1


# mkdir import
# mkdir -p 'import/content'
# mkdir -p 'import/log'
# wget -O 'import/content/import.zip' https://www.dropbox.com/sh/cb9jafsv42ju252/AABSa6WyNlnMHeyLg_VaDHgwa?dl=1
# unzip -x -LL import/content/import.zip -d 'import/content/import'
# rm -R import/content/import/__macosx/
# rm -R import/content/import/cancelled-*
