# Adding a Site Version

This file will list steps that you must go through when adding a new site version.

1. Remember that a site version **MUST** contain values like:

Attribute     | Possible Values
------------- | -------------
Name          | "Australia" (String)
Permalink     | "au" (String)
Currency      | "AUD" (String)
Locale        | "en-AU" (String)
Domain        | "www.fameandpartners.com.au" (String)

2. Don't forget to add the new site version domain on the cookie session store configuration, otherwise, cookies will not be shared between domains, and orders between websites will be lost.
    - See `COOKIE_STORE_DOMAINS` at `/config/initializers/session_store.rb`

## Legacy

Site versions were detected as paths on the URL (e.g. `/au`, `/`), and they changed this behaviour.
