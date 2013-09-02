namespace "db" do
  namespace "populate" do
    desc "set default products positions"
    task product_positions: :environment do
      set_default_products_order
    end
  end
end

def set_default_products_order
  list = get_products_list
  Spree::Product.update_all(position: (list.length + 1))

  list.each_with_index do |product_url, index|
    Spree::Product.where(permalink: product_url).update_all(position: index)
  end
end

def get_products_list
  return [
    'dramatic-silk',
    'grecian-goddess',
    'flirty-georgette-dress',
    'dramatic-cut-out-dress',
    'black-swan',
    'grecian-bohemian',
    'heavenly-tulle',
    'sweetheart-high-low',
    'mesh-glamour',
    'hourglass-glamour',
    'draped-twist',
    'hi-low-lace-tube-dress',
    'marilyn-moment',
    'form-fitting-strapless-dress',
    'sheer-panels',
    'sexy-backless-twist',
    'graphic-cutout',
    'piped-bodice',
    'the-show-stopper',
    'silverscreen-glamour',
    'satin-gown-with-detailed-train',
    'elegant-lace',
    'elegant-minidress',
    'elegant-minidress-scoop-neck',
    'playful-taffeta-minidress',
    'classic-and-elegant',
    'exquisite-ruffle-dress',
    'sleek-mini-dress',
    'structured-curves',
    'flirty-tie-it-up-dress',
    'girly-a-line',
    'classic-strapless-gown-with-peplum-detail',
    'layered-taffeta',
    'sweet-ruffle-dress',
    'playful-taffeta-cut-out-dress',
    'strapless-satin-minidress-with-tulle',
    'streamlined-mini',
    'satin-minidress-for-a-fun-night-out',
    'the-beaded-two-piece'
  ]
end
