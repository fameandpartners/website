# Requirements

Make sure your engine yard credentials are working

`$ gem install engineyard`

# IMPORTANT Note on Deployment

In general, we deploy fixes as we go.

As a general rule, feature flags should be used to control and test changes in the production environment before being flipped for general use.

Migrations that have been designed for zero-downtime deployments can be deployed freely.

# Process

## Deploy to production

Merge master to stable, tag, and push

* `$ git checkout stable`
* `$ git merge master --ff-only`
* `$ git tag \`date +v%Y-%m-%d-T%H%M%S%z\``
* `$ git push --tags`
  * You also can enable pushing tags automatically with `push.followTags`
* Login to Engine Yard
* Select `Migrate` and enter `rake db:migrate`
* Enter the tag in the `ref` field

Note: You can find the tag that was created by using `$ git tag`, copying and pasting into engine yard.  
