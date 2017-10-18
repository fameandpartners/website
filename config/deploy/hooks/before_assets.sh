#!/bin/bash

##################################################
# NOTE: JS bundling at the `assets.rake` rake file
##################################################

# Persist npm modules across deploys.
# installation actually happens in a rake task after assets:precompile
shared_modules_path="${shared_app_path}/node_modules"
# ensure shared modules dir exists
mkdir -p ${shared_modules_path}
# symlink to current app
ln -s ${shared_modules_path} ${this_release_dir}/node_modules

# install npm modules
cd ${this_release_dir}
yarn install && yarn run prod

cd ${this_release_dir/app/shopping-spree && npm i
