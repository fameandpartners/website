#!/bin/sh

# DO NOT RUN THIS BLINDLY
#
# import_products.sh
#
# A super unsophisticated script to load in all new and existing products from a single directory.
# Only works with a custom crafted directory structure.
#
# Made on the fly during the website relaunch of March 2015
#
# To prepare the directory I
#
# 1. Took the full ProductUpload directory from Marketing. (Tan)
# 2. Removed all the ARCHIVE or Archive directories.
# 3. Removed all spreadsheets which where obviously not real e.g. "$~MasterContent_SalesPage.xlsx"
# 4. Renamed any directories or files with single quotes (') - There were only one or two.
# 5. Renamed missing product SKU directories
#     - 'Drop1-USProm/4B290B-Emma Kate' => "Drop1-USProm/4B290-Emma Kate"
#     - 'Drop2-GlamorousRebel/4B283-Glam Lace' => 'Drop2-GlamorousRebel/4B283B-Glam Lace'

# TODO Before running
# 1. Shrink the images using Toby's cool script.case
# 2. Catch errors a bit better, at the moment we need to trawl the entire log file!
# 3. Lots

# Skip execution of the actual rake tasks, pass 'dryrun' as the first argument.
# $ scripts/import_products.sh dryrun

# Fail on missing variables.
set -u
# Fail on failures in pipes
set -o pipefail

dryrun=${1:-}

# Init
import_start_time=$(date '+%Y-%m-%d_%H.%M.%S')
logfile="log/product_import_${import_start_time}.log"
log_date_format='%Y-%m-%d %H:%M:%S'

content_directory='/home/deploy/IMAGES/'

# For easier local testing
if [ $(whoami) = "garrow" ] ; then
  content_directory='/Users/garrow/fame/content/ProductUpload'
fi

# For easier local testing
if [ $(whoami) = "tobyhede" ] ; then
  content_directory='/Users/tobyhede/documents/fame/ProductUpload'
fi

spreadsheets=$(find ${content_directory} -name '*.xls*' |grep -v "~")
image_directories=$(find "${content_directory}"  -maxdepth 1  -mindepth 1 -type d | grep -vi spreadsheet)
image_types=(product customization moodboard song)
# rake import:accessory:images                      # Import images for accessories (specify directory location w/ LOCATION=/path/to/directory)
# rake import:customization:images                  # Import images for customizations (specify directory location w/ LOCATION=/path/to/directory)
# rake import:moodboard:images                      # Import images for moodboards (specify directory location w/ LOCATION=/path/to/directory)
# rake import:product:images                        # Import images for products (specify directory location w/ LOCATION=/path/to/directory)
# rake import:song:images

# Executed at EOF
function main
{
  fix_image_directories
  import_spreadsheets
  import_images
  reindex_products
  expire_caches
  info "See log for details: $logfile"
}

function reindex_products
{
  info "Reindexing Products"
  if [ "$dryrun" = "dryrun"  ]; then return; fi
  bundle exec rake import:product:reindex
}

function expire_caches
{
  info "EXPIRING ALL CACHES"
  if [ "$dryrun" = "dryrun"  ]; then return; fi
  bundle exec rake cache:expire
}

function import_spreadsheets
{
  for xls in ${spreadsheets[@]}; do import_product_spreadsheet ${xls} ; done
}

function fix_image_directories
{
  info "Fixing known bad image directories"

  fix_image_directory "Drop1-USProm/4B290B-Emma Kate"        "Drop1-USProm/4B290-Emma Kate"
  fix_image_directory "Drop2-GlamorousRebel/4B283-Glam Lace" "Drop2-GlamorousRebel/4B283B-Glam Lace"
}

function fix_image_directory()
{
  bad_dir="${content_directory}/$1"
  fix_dir="${content_directory}/$2"
  if [ -d "$bad_dir" ]; then
    info "Moving $bad_dir -> $fix_dir"

    if [ "$dryrun" = "dryrun" ]; then return; fi
    mv "$bad_dir" "$fix_dir"
  elif [ -d "$fix_dir" ]; then
    info "Directory already fixed ${fix_dir}"
  fi
}

function import_images
{
  for drop_directory in ${image_directories[@]}; do import_images_for_drop "$drop_directory";  done
}

function import_images_for_drop()
{
  directory=$1
  info "Importing from $directory"
  if [ ! -d "$directory" ]; then
    error "$directory Images Directory not readable, skipping"
    return
  fi
  export LOCATION=$directory
  for type in "${image_types[@]}" ; do import_images_type "$type"; done
}

function import_images_type()
{
  images_type=$1
  info "Importing [$images_type] from ${LOCATION}"
  #e.g. $ bundle exec rake import:moodboard:images LOCATION=~/fame/content/ProductUpload/Drop1-USProm

  if [ "$dryrun" = "dryrun"  ]; then return; fi
  bundle exec rake import:${images_type}:images || error "FAILED!"
}

function import_product_spreadsheet()
{
  spreadsheet=$1
  if [ ! -r "$spreadsheet" ]; then
    error "$spreadsheet File not readable, skipping"
    return
  fi
  info "Importing $spreadsheet"
  export FILE_PATH=$spreadsheet
  if [ $dryrun ]; then return; fi
  bundle exec rake import:data || error "FAILED!"
}

function error() { echo $(red)[$(date +"$log_date_format")][E]  $*$(normal); }
function info() { echo $(yellow)[$(date +"$log_date_format")][I]  $*$(normal); }
function success() { echo $(green)[$(date +"$log_date_format")][S]  $*$(normal); }
function hl() { $(tput rev)$*$(tput rev); }

function normal  { tput sgr0;    }
function red     { tput setaf 1; }
function green   { tput setaf 2; }
function yellow  { tput setaf 3; }
function blue    { tput setaf 4; }

head -n 28 $0
read -p "Enter to continue, or Ctrl-C to cancel!"

time main | tee $logfile
