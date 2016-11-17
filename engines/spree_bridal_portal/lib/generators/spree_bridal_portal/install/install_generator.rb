module SpreeBridalPortal
  module Generators
    class InstallGenerator < Rails::Generators::Base
      def add_javascripts
        # append_file 'app/assets/javascripts/store/all.js', "//= require store/spree_bridal_portal\n"
        # append_file 'app/assets/javascripts/admin/all.js', "//= require admin/spree_bridal_portal\n"
      end

      def add_stylesheets
        # inject_into_file 'app/assets/stylesheets/store/all.css', " *= require store/spree_bridal_portal\n", :before => /\*\//, :verbose => true
        # inject_into_file 'app/assets/stylesheets/admin/all.css', " *= require admin/spree_bridal_portal\n", :before => /\*\//, :verbose => true
      end

      def add_migrations
        run 'bundle exec rake railties:install:migrations FROM=spree_bridal_portal'
      end

      def run_migrations
        res = ask 'Would you like to run the migrations now? [Y/n]'
        if res == '' || res.casecmp
          run 'bundle exec rake db:migrate'
        else
          puts 'Skipping rake db:migrate, don\'t forget to run it!'
        end
      end
    end
  end
end
