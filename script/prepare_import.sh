#!/bin/bash

#  Prepare - Zip File to Import Dir
#
#  Prepare accepts a path and a url, and downloads a zip file,
#  processes the file and cleans any extraneous data.
#
#  To download a zipped file of a folder's contents from dropbox make
#  sure the url is appended with ?dl=1
#
#  prepare_import.sh zip_file_url [import_directory]
#
#    zip_file_url         URL of a zip file, accessible via http/s
#    import_directory     Optional: Defaults to $HOME
#
#  == Examples ==
#
#  Using home directory and dropbox URL
#    prepare_import.sh https://www.dropbox.com/sh/ar0b57n8nfnt82s/AADNNbbuOqExZ12voP46Oe07a?dl=1
#
#  Using custom directory and custom link
#    prepare_import.sh https://example.com/import_data.zip /tmp/content

function _preamble
{
  # Prints all lines of this file, up to the beginning of this function, minus the shebang line, (#!)
  start_of_func=$(cat $0 | grep -ne "${FUNCNAME[0]}" -m 1 | cut -f1 -d: )
  print_from=$(expr $start_of_func - 1)
  print_to=$(expr $start_of_func - 2)
  head -n $print_from $0 | tail -n $print_to | cut -d# -f2-
}

# Fail on missing variables.
set -u
# Fail on failures in pipes
set -o pipefail

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

  info "Deleting $(blue)'${dirty_pattern}'$(yellow) items from $(green)${from_path}"
  find "${from_path}" -name "${dirty_pattern}" |while read fname; do
    _delete_warn "$fname"
  done
}

function _ensure_dropbox_dl_link
{
  dl_zero=$(echo $1 | grep -e 'dl=0$')
  if [ "${1}" = "${dl_zero}" ]; then
    echo  "$(red)Warning! The download link appears to be a Dropbox view (not download) link!$(normal)"
    echo  "$(red)Fix: Changing $(yellow)dl=0$(red) to $(yellow)dl=1$(red) will make Dropbox build a zip file.$(normal)"
  fi
}

function prepare
{
  SOURCE_FILE=$1
  BASE_PATH=$2

  _ensure_dropbox_dl_link $SOURCE_FILE

  working_path="${BASE_PATH}/import"
  content_path="${working_path}/content"
  log_path="${working_path}/log"
  extract_path="${content_path}/extract/"
  zip_file_path="${content_path}/import.zip"

  echo "Downloading From: $(blue)${SOURCE_FILE}$(normal)"
  echo "To Directory:     $(green)${working_path}$(normal)"
  echo
  echo "Press $(green)Enter$(normal) to continue, or $(red)Ctrl-C$(normal) to cancel!"
  echo not waiting for stdin
  sleep 2

  _mkdir_p "${working_path}"
  _mkdir_p "${content_path}"
  _mkdir_p "${log_path}"

  _delete_warn "${extract_path}"
  _mkdir_p "${extract_path}"

  info "Downloading $(blue)${SOURCE_FILE}"
  wget -O "${zip_file_path}" $SOURCE_FILE
  _fail_on_error $? "Error Downloading"

  info "Checking file $(blue)${zip_file_path}"
  unzip -tq "${zip_file_path}"
  _fail_on_error $? "Bad Zip File"

  info "Extracting $(blue)${zip_file_path}$(yellow) to $(green)${extract_path}"
  # -LL Converts all filenames to lowercase, needed for cross platform created zip files.
  unzip -x -LL "${zip_file_path}" -d "${extract_path}" | grep 'creating:'

  _clean_from_path '__macosx' "${extract_path}"
  _clean_from_path '*cancelled*' "${extract_path}"
}

function import {
  cd /data/fame_and_partners/current
  ./script/import_products.sh dryrun
  ./script/import_products.sh
}

############ Output ############
log_date_format='%Y-%m-%d %H:%M:%S'
function error() { echo $(red)[$(date +"$log_date_format")][E]  $*$(normal); }
function info() { echo $(yellow)[$(date +"$log_date_format")][I]  $*$(normal); }
function success() { echo $(green)[$(date +"$log_date_format")][S]  $*$(normal); }

function normal  { tput sgr0;    }
function red     { tput setaf 1; }
function green   { tput setaf 2; }
function yellow  { tput setaf 3; }
function blue    { tput setaf 4; }

function _fail_on_error
{
  if [[ $1 != 0 ]]; then
    error $2
    exit $1
  fi
}

############ Main ############
_preamble

zip_file_url=$1
import_directory=${2-$HOME}

prepare $zip_file_url $import_directory


# mkdir import
# mkdir -p 'import/content'
# mkdir -p 'import/log'
# wget -O 'import/content/import.zip' https://www.dropbox.com/sh/cb9jafsv42ju252/AABSa6WyNlnMHeyLg_VaDHgwa?dl=1
# unzip -x -LL import/content/import.zip -d 'import/content/import'
# rm -R import/content/import/__macosx/
# rm -R import/content/import/cancelled-*
rm ~/import/content/extract/fp2683/fp2683-sh* || true
