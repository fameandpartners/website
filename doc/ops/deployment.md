# Deployment

## IMPORTANT Note on Deployment

- In general, we deploy fixes as we go.
- As a general rule, feature flags should be used to control and test changes in the production environment before being flipped for general use.
- Migrations that have been designed for zero-downtime deployments can be deployed freely.
- Tags have the following date time format: `+v%Y-%m-%d-T%H%M%S%z`

# Process

- `master` branch represents merged and accepted pull requests
- `stable` branch represents code that's ready to go to production
- Git tags are used to tag code releases to **production**


# Deploying

To deploy to any environment, you must have a valid Reinteractive's Sentinel token. More details are documented on [cloud environment docs.](cloud-environments.md)

After you have a valid Sentinel token, create a new copy of the `OpsCare.yml.example` file, renaming it to `OpsCare.yml`, and configure it with the desired values.

## Staging

Run `sentinel deploy staging`

### Deploying a specific branch

To deploy a specific branch, use the `--branch-name` option: `sentinel deploy staging --branch-name feat/my-awesome-branch`

### Faster deploys on staging

On staging environment, you don't need to follow all steps which `Sentinel` tool introduces to the deployment process (real zero downtime deployments, snapshots, etc.).

To achieve that:

1. SSH into the staging machine: `sentinel ssh staging --role web`
2. Go to the app folder: `cdapp`
3. Use the deploy command with the desired branch name: `deploy --branch=feature/super-new-one`

This will execute the deployment process straight into the staging machine, only copying new code from the repository and executing it against the existent isntance.

## Production

### Local Machine

Merge stable with master, tag and push it

1. Checkout stable (`git checkout stable`)
1. Merge stable with master (`git merge master --ff-only`)
1. Tag it (`` git tag `date +v%Y-%m-%d-T%H%M%S%z` ``)
1. Push stable with tags to origin (`git push stable --tags`)

After `stable` branch is updated, run `sentinel deploy production`.

# LEGACY

**IMPORTANT NOTE**: EngineYard is no longer used!

## Deploy to preproduction

Just use `master`, branch name or any git ref hash that you wish to test features on preprod environment.

## Deploy to production

### Local Machine

Merge stable with master, tag and push it

1. Checkout stable (`git checkout stable`)
1. Merge stable with master (`git merge master --ff-only`)
1. Tag it (`` git tag `date +v%Y-%m-%d-T%H%M%S%z` ``)
1. Push stable with tags to origin (`git push stable --tags`)

### Engine Yard

Deploy the created tag to production

1. Login to EY
1. Select `Migrate` and enable `rake db:migrate` on deployments
1. Enter the tag in the `ref` field

> Note: You can find the tag that was created by using `$ git tag`, copying and pasting into engine yard.
