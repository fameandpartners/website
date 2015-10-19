# Trackers and Analytics

To be able to test out Google Analytics and other trackers on development, please make sure that:

- You have `Features.activate(:test_analytics)`
- You have setup a valid `Spree::Tracker`:
 
 ```ruby
 Spree::Tracker.create(environment: 'development', analytics_id: 'UA-XXXXXXXX-X', active: true)
 Spree::Tracker.current
 # => #<Spree::Tracker id: 2, environment: "development", analytics_id: ... ">
 ```

## Notable files:

- `/app/views/marketing/_sync_trackers.html.slim`
- `/app/views/marketing/trackers/_google_analytics.html.erb`
