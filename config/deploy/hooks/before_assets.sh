#!/bin/bash

# Persist npm modules acros deploys.
# installation actually happens in a rake task after assets:precompile
shared_modules_path="${shared_app_path}/node_modules"
# ensure shared modules dir exists
mkdir -p ${shared_modules_path}
# symlink to current app
ln -s ${shared_modules_path} ${this_release_dir}/node_modules
