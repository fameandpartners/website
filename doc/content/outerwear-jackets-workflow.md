# How Outerwear/Jackets work? 

Jackets/Outerwear can be considered a feature spike, since they are a quick adaptation of a different product type (instead of `dresses`, we also would have `jackets`).

Currently this adaptation can be viewed/used using the following: 

- Products are considered outerwear once they belong to a taxon that is child of the "Outerwear" taxonomy
    - **Implementation** `scope`: https://github.com/fameandpartners/website/blob/0960bb0c446fcb4e6a0112424356bef5bfdb0bd4/app/models/spree/product_decorator.rb#L52-52
- Admin users can create "related outerwear"
    - Interface is right above the "meta description" field inside Spree's admin product edition. (e.g. "/admin/products/about_love/edit")
    - It's a searchable `select2` interface, built-in in spree admin
- Related outerwear will show on product details page, if not empty
    - **Implementation** `source`: https://github.com/fameandpartners/website/blob/0960bb0c446fcb4e6a0112424356bef5bfdb0bd4/app/views/products/details/_related_products.html.slim#L8
- A product that is an outerwear can be accessed through the following URL: `get '/dresses/outerwear-:product_slug'`
    - This routing can be achieved using the "type" parameter on routing method `#collection_product_path`. More at https://github.com/fameandpartners/website/blob/0960bb0c446fcb4e6a0112424356bef5bfdb0bd4/app/views/products/details/_related_products.html.slim#L17-L21
- Outerwears are not listed anywhere (collections or searches), until they are explicitly queried (e.g. `/dresses/outerwear`)
    - Filtering at: https://github.com/fameandpartners/website/blob/0960bb0c446fcb4e6a0112424356bef5bfdb0bd4/app/services/search/color_variants_query.rb#L47-L51
    - Collection controller: https://github.com/fameandpartners/website/blob/0960bb0c446fcb4e6a0112424356bef5bfdb0bd4/app/controllers/products/collections_controller.rb#L156-L160
