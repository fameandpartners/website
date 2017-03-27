#!/bin/bash
IMAGES_LOCATION=~/Dropbox/3dRender/02_Finished/
FOLDER_NAMES=('D1-FP2212' 'D3-FP2214' 'D5-FP2216' 'D7-FP2218' 'D2-FP2213' 'D4-FP2215' 'D6-FP2220' 'D8-FP2219')
ELEMENTS=${#FOLDER_NAMES[@]}
for (( i=0;i<$ELEMENTS;i++)); do
  FOLDER=$IMAGES_LOCATION${FOLDER_NAMES[${i}]}
  find -L ${FOLDER} -type d -regex '.*' | while read name; do
    grey="180(x|X)260/(G|g)rey$"
    white="180(x|X)260/(W|w)hite$"
    small="280(x|X)404$"
    medium="900(x|X)1300$"
    large="1800(x|X)2600$"
    set -v
    if [[ "$name" =~ $grey ]]; then
      echo "Starting upload for $name"
      aws s3 sync $name/. s3://fandp-web-qa1/wedding-atelier/dresses/180x260/grey/ --acl=public-read
      echo "Upload done for $name"
    fi
    if [[ "$name" =~ $white ]]; then
      echo "Starting upload for $name"
      aws s3 sync $name/. s3://fandp-web-qa1/wedding-atelier/dresses/180x260/white/ --acl=public-read
      echo "Upload done for $name"
    fi
    if [[ "$name" =~ $small ]]; then
      echo "Starting upload for $name"
      aws s3 sync $name/. s3://fandp-web-qa1/wedding-atelier/dresses/280x404/ --acl=public-read
      echo "Upload done for $name"
    fi
    if [[ "$name" =~ $medium ]]; then
      echo "Starting upload for $name"
      aws s3 sync $name/. s3://fandp-web-qa1/wedding-atelier/dresses/900x1300/ --acl=public-read
      echo "Upload done for $name"
    fi
    if [[ "$name" =~ $large ]]; then
      echo "Starting upload for $name"
      aws s3 sync $name/. s3://fandp-web-qa1/wedding-atelier/dresses/1800x2600/ --acl=public-read
      echo "Upload done for $name"
    fi
  done

done
