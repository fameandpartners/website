# Trackers and Analytics

To be able to test out Google Analytics and other trackers on development, please make sure that:

- You have `Features.activate(:test_analytics)`
- You have setup a valid `Spree::Tracker`:
 
 ```ruby
 Spree::Tracker.create(environment: 'development', analytics_id: 'UA-XXXXXXXX-X', active: true)
 Spree::Tracker.current
 # => #<Spree::Tracker id: 2, environment: "development", analytics_id: ... ">
 ```

## Google Analytics documentation

Enabling `:test_analytics` feature flag, you'll multiple domain tracking on dev machine. For more details about it, refer to: 

- [Legacy Google Analytics Docs](https://developers.google.com/analytics/devguides/collection/gajs/methods/gaJSApiDomainDirectory?hl=en#_setdomainname)
- [Universal Google Analytics](https://developers.google.com/analytics/devguides/collection/analyticsjs/field-reference#cookieDomain)

## Notable files:

- `/app/views/marketing/_sync_trackers.html.slim`
- `/app/views/marketing/trackers/_google_analytics.html.erb`
