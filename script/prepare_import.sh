#!/bin/bash

#  Prepare - Dropbox to Import Dir
#
#  Prepare accepts a path and a url, and downloads a zip file from dropbox,
#  process the file and cleans any extraneous data.
#
#  To download a zipped file of a folder's contents from dropbox make
#  sure the url is appended with ?dl=1
#
#  ./script/prepare_import.sh {location} {url}
#  ./script/prepare_import.sh ~ https://www.dropbox.com/sh/ar0b57n8nfnt82s/AADNNbbuOqExZ12voP46Oe07a?dl=1


# Fail on missing variables.
set -u
# Fail on failures in pipes
set -o pipefail

function _preamble
{
  head -n 13 $0 | tail -n 12
}

function _mkdir_p
{
  directory_path=$1
  info "Creating Dir: $(green)${directory_path}"
  mkdir -p "${directory_path}"
}

function _delete_warn
{
  thing_to_delete=$1
  info "Deleting: $(red)${thing_to_delete}"
  rm -rf "${thing_to_delete}"
}

function _clean_from_path
{
  dirty_pattern="${1}"
  from_path="${2}"

  info "Deleting $(normal)'${dirty_pattern}'$(yellow) items from $(green)${from_path}"
  find "${from_path}" -name "${dirty_pattern}" |while read fname; do
    _delete_warn "$fname"
  done
}

function prepare
{
  BASE_PATH=$1
  SOURCE_FILE=$2


  working_path="${BASE_PATH}/import"
  content_path="${working_path}/content"
  log_path="${working_path}/log"
  extract_path="${content_path}/extract/"
  zip_file_path="${content_path}/import.zip"

  echo "Downloading: $(blue)${SOURCE_FILE}$(normal)"
  echo "To: $(green)${working_path}$(normal)"
  read -p "Enter to continue, or Ctrl-C to cancel!"

  _mkdir_p "${working_path}"
  _mkdir_p "${content_path}"
  _mkdir_p "${log_path}"

  _delete_warn "${extract_path}"
  _mkdir_p "${extract_path}"

  info "Downloading $(blue)${SOURCE_FILE}"
  wget -O "${zip_file_path}" $SOURCE_FILE

  info "Checking file $(blue)${zip_file_path}"
  unzip -tq "${zip_file_path}"
  info "Extracting $(blue)${zip_file_path}$(yellow) to $(green)${extract_path}"

  unzip -x -LL "${zip_file_path}" -d "${extract_path}" | grep 'creating:'

  _clean_from_path '__macosx' "${extract_path}"
  _clean_from_path '*cancelled*' "${extract_path}"
}

function import {
  cd /data/fame_and_partners/current
  ./script/import_products.sh dryrun
  ./script/import_products.sh
}

# ########### Output ############
log_date_format='%Y-%m-%d %H:%M:%S'
function error() { echo $(red)[$(date +"$log_date_format")][E]  $*$(normal); }
function info() { echo $(yellow)[$(date +"$log_date_format")][I]  $*$(normal); }
function success() { echo $(green)[$(date +"$log_date_format")][S]  $*$(normal); }

function normal  { tput sgr0;    }
function red     { tput setaf 1; }
function green   { tput setaf 2; }
function yellow  { tput setaf 3; }
function blue    { tput setaf 4; }

#### Main
_preamble
prepare $1 $2


# mkdir import
# mkdir -p 'import/content'
# mkdir -p 'import/log'
# wget -O 'import/content/import.zip' https://www.dropbox.com/sh/cb9jafsv42ju252/AABSa6WyNlnMHeyLg_VaDHgwa?dl=1
# unzip -x -LL import/content/import.zip -d 'import/content/import'
# rm -R import/content/import/__macosx/
# rm -R import/content/import/cancelled-*
