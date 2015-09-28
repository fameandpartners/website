# Requirements

Make sure your engine yard credentials are working

`$ gem install engineyard`

# IMPORTANT Note on Deployment

In general, we deploy fixes as we go.
However, any deployments requiring migration (see below) or that have any chance of directly impacting sales (changes to payment gateways, for example) should only occur within our Deployment Window.

The current deployment window is 18:00-20:00 AEST which is currently 04:00-06:00 EST and 01:00-03:00 PST.

As a general rule, feature flags should be used to control and test changes in the production environment before being flipped for general use.

Migrations that have been designed for zero-downtime deployment are excepted and can be deployed freely.

# Process

## Deploy to production

Merge master to stable and push

* `$ git checkout stable`
* `$ git merge master --ff-only`
* `$ git git push`
* `$ ey deploy -e production_new --no-migrate`

To deploy with migrations (will turn maintenance mode on meaning site is down)

* `$ ey deploy -e production_new`

## Deploy to preproduction

Deploy any working branch to preprod

* `$ git checkout {branch}`
* `$ ey deploy -e preprod  --no-migrate`

To deploy with migrations (will turn maintenance mode on meaning site is down)

* `$ ey deploy -e preprod `
