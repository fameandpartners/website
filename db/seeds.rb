# encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create!([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create!(name: 'Emanuel', city: cities.first)

Spree::Core::Engine.load_seed if defined?(Spree::Core)
Spree::Auth::Engine.load_seed if defined?(Spree::Auth)

# Config
password    = "qwerty12"
admin_role  = Spree::Role.find_by_name "admin"
editor_role = Spree::Role.find_by_name "user"

# Create Users
["James Kirk", "Leonard McCoy"].each do |admin|
  user = Spree::User.new first_name: admin.split.first, last_name: admin.split.last,
                         email: "#{admin.split.last}@admin.com", password: password,
                         password_confirmation: password
  user.spree_roles << admin_role
  user.save!
  user.confirm!
end

["Luke Skywalker", "Leonard Nimoy", "Tony Stark", "Clark Kent", "Sheldon Cooper"].each do |editor|
  user = Spree::User.new first_name: editor.split.first, last_name: editor.split.last,
                         email: "#{editor.split.last}@editor.com", password: password,
                         password_confirmation: password
  user.spree_roles << editor_role
  user.save!
  user.confirm!
end
