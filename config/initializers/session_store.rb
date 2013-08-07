# Be sure to restart your server when you modify this file.

FameAndPartners::Application.config.session_store :cookie_store, {
  key: '_fame_and_partners_pre_production_session',
  domain: :all
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# FameAndPartners::Application.config.session_store :active_record_store
