# Please, aggregate flags by deactivated/activated groups, and sorted by alphabetical order
# This organization helps a lot on finding what's active or not on each env

# NB: This has now become an area only for development and test environments as there is
#     now a UI to control the switching on and off of flags.  Setting it here will
#     override the UI setting.
#     To create a new Feature Flag put it in migrations!  Not here as this resets the value every time!


if Rails.env.development?
  Features.deactivate(:test_analytics)
end

if Rails.env.test?
  Features.deactivate(:force_sitewide_ssl)
  Features.deactivate(:google_tag_manager)
  Features.deactivate(:test_analytics)
end
