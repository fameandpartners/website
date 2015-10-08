# Content Quality Issues

There are a couple of rake tasks available for cleaning up broken data, most live under the `quality` namespace.
See: `lib/tasks/quality/`

## Missing Prices on `Spree::Variants`

Sometimes we end up with Spree::Variants which don't have prices set correctly for all currencies, or which have incorrect prices.

The rake task `quality:fix_variants_missing_prices` will add missing (usually USD) prices.
It will default to the AUD price if USD is not present.
See: `lib/tasks/quality/variants_missing_prices.rake`

## Incorrect Values for Prices on `Spree::Variants`

The Spree::Product UI will update prices on all variants of a product when saving the product (which saves the master variant).

The callback `push_changed_prices_to_variants` attempts to configure the prices on all variants to be the same price as the master variant. 

See: `app/models/spree/variant_decorator.rb`
