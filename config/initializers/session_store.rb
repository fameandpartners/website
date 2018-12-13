# Be sure to restart your server when you modify this file.

COOKIE_STORE_DOMAINS = [
    '.lvh.me',
    '.fameandpartners.com.au',
    '.fameandpartners.com',
    '.fameandgroups.com',
    '.fameandgroups.com.au'
]

FameAndPartners::Application.config.session_store :cookie_store, {
  key: "_fame_and_partners_#{ Rails.env.to_s }_session",
  domain: COOKIE_STORE_DOMAINS
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# FameAndPartners::Application.config.session_store :active_record_store
