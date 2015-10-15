#!/bin/bash

function prepare
{
  IMPORT_PATH=$1
  SOURCE_FILE=$2
  echo "Downloading: $SOURCE_FILE"
  echo "To: $IMPORT_PATH/import"

  mkdir "$IMPORT_PATH/import"
  mkdir -p "$IMPORT_PATH/import/content"
  mkdir -p "$IMPORT_PATH/import/log"

  wget -O "$IMPORT_PATH/import/content/import.zip" $SOURCE_FILE
  unzip -x -LL "$IMPORT_PATH/import/content/import.zip" -d "$IMPORT_PATH/import/content/import"

  rm -R "$IMPORT_PATH/import/content/import/__macosx/"
  rm -R "$IPORT_PATH/import/content/import/cancelled-*"
}

function import {
  cd /data/fame_and_partners/current
  ./script/import_products.sh dryrun
  ./script/import_products.sh
}

prepare $1 $2


# mkdir import
# mkdir -p 'import/content'
# mkdir -p 'import/log'
# wget -O 'import/content/import.zip' https://www.dropbox.com/sh/cb9jafsv42ju252/AABSa6WyNlnMHeyLg_VaDHgwa?dl=1
# unzip -x -LL import/content/import.zip -d 'import/content/import'
# rm -R import/content/import/__macosx/
# rm -R import/content/import/cancelled-*
