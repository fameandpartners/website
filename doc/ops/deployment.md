# Deployment

## IMPORTANT Note on Deployment

- In general, we deploy fixes as we go.
- As a general rule, feature flags should be used to control and test changes in the production environment before being flipped for general use.
- Migrations that have been designed for zero-downtime deployments can be deployed freely.
- Tags have the following date time format: `+v%Y-%m-%d-T%H%M%S%z`

# Process

- `staging` branch represents code that's still pending approvals/QA
- `master` branch represents merged and accepted pull requests
- `stable` branch represents code that's ready to go to production
- Git tags are used to tag code releases to **production**


# Deploying

To deploy to any environment, you must have a valid Reinteractive's Sentinel token. More details are documented on [cloud environment docs.](cloud-environments.md)

After you have a valid Sentinel token, create a new copy of the `OpsCare.yml.example` file, renaming it to `OpsCare.yml`, and configure it with the desired values.

## Staging, QA1 and QA2 environments

We have 3 environments for preview/feedback: Staging, QA1 and QA2.

- **Staging** is dedicated to PRs that are merged onto the `staging` branch. This is the place for in-progress/under-review PRs that need previews and approvals (from the Design & Marketing teams, for example).

- **QA1** is currently dedicated to Magma Labs, where they can play exclusively with their branches for the new App.

- **QA2** is dedicated to deploying single PRs for final QA reviews.

**Important:** be sure to have QA1 / QA2 info in your `OpsCare.yml` file. See [`OpsCare.yml.example`](https://github.com/fameandpartners/website/blob/master/OpsCare.yml.example) for references.

## Example flow for STAGING env:

> - Pushed my branch `feature/WEBSITE-123/super-branch`
> - Then `git checkout staging`
> - Then `git merge feature/WEBSITE-123/super-branch`
> - Then `git push origin staging`

**Faster deployment:**

> - SSH into the staging machine: `sentinel ssh staging --role web`
> - Go to the app folder: `cdapp`
> - Use the deploy command: `deploy --branch=staging`

**Slower deployments (zero downtime, snapshots etc.):**

> Just run `sentinel deploy staging --branch-name staging`

*_Notes_*

- `staging` branch *will* become polluted. At the end of sprints, we'll simply revert it and force push on it to current stable/master or whatever. It'll act as an *ephemeral* branch.
- Git history will become uglier. It's never pretty with more than 2 people working on the same codebase. Diffs matter, visual history, not so much.

## Example flow for QA2 env:

**Faster deployment:**

> - SSH into the QA2 machine: `sentinel ssh qa2 --role web`
> - Go to the app folder: `cdapp`
> - Use the deploy command: `deploy --branch=feature/WEBSITE-123/super-branch`

**Slower deployments (zero downtime, snapshots etc.):**

> Just run `sentinel deploy qa2 --branch-name feature/WEBSITE-123/super-branch`


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
