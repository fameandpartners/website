#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Test::Unit::AutoRunner.need_auto_run = false if defined?(Test::Unit::AutoRunner)

Knapsack.load_task if defined?(Knapsack)

FameAndPartners::Application.load_tasks
