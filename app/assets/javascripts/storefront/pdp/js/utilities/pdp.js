/* eslint-disable max-len */
import { assign } from 'lodash';
import { formatCents } from './accounting';
import { UNITS } from '../constants/ProductConstants';

export function calculateSubTotal({
  colorCentsTotal = 0,
  productCentsBasePrice = 0,
  selectedAddonOptions = [],
}) {
  const customizationStyleCents = selectedAddonOptions
    .reduce((prev, curr) => prev + parseInt(curr.centsTotal, 10), 0);

  return formatCents(
    parseInt(colorCentsTotal, 10) + customizationStyleCents + productCentsBasePrice,
    0,
  );
}

function filterSelectedAddons(addonOptions, selectedStyleCustomizations) {
  return addonOptions
    .filter(a => selectedStyleCustomizations.indexOf(a.id) > -1)
    .map(a => ({
      id: a.id,
      description: a.description,
      centsTotal: a.centsTotal,
    }));
}

export function sizingDisplayText({
  selectedHeightValue,
  selectedMeasurementMetric,
  selectedDressSize }) {
  let sizingInformation = null;

  if (selectedHeightValue && selectedDressSize) {
    if (selectedMeasurementMetric === UNITS.INCH) {
      // INCH
      const ft = Math.floor(selectedHeightValue / 12);
      const inch = selectedHeightValue % 12;
      sizingInformation = `${ft}ft ${inch}in / ${selectedDressSize}`;
    } else {
      // CM
      sizingInformation = `${selectedHeightValue} ${selectedMeasurementMetric.toLowerCase()} / ${selectedDressSize}`;
    }
  }
  return sizingInformation;
}

export function reduceCustomizationSelectionPrice({ selectedAddonOptions }) {
  return `+${formatCents(
    selectedAddonOptions.reduce(
      (subTotal, c) =>
      subTotal + parseInt(c.price.money.fractional, 10), 0),
      0,
    )}`;
}

export function addonSelectionDisplayText({ selectedAddonOptions }) {
  if (selectedAddonOptions.length === 1) { // One customization
    return `${selectedAddonOptions[0].description} +${formatCents(parseInt(selectedAddonOptions[0].centsTotal, 10), 0)}`;
  } else if (selectedAddonOptions.length > 1) { // Multiple customizations
    return `${selectedAddonOptions.length} Additions ${reduceCustomizationSelectionPrice({ selectedAddonOptions })}`;
  }
  return null;
}

export function accumulateCustomizationSelections({ $$customizationState, $$productState }) {
  const productId = $$productState.get('productId');
  const productTitle = $$productState.get('productTitle');
  const productImage = $$productState.get('productImages').get(0).get('bigImg');
  const productCentsBasePrice = $$productState.get('productCentsBasePrice');
  const color = $$customizationState.get('selectedColor').toJS();
  const selectedStyleCustomizations = $$customizationState.get('selectedStyleCustomizations').toJS();
  const addonOptions = $$customizationState.get('addons').get('addonOptions').toJS();
  const addons = filterSelectedAddons(addonOptions, selectedStyleCustomizations);

  return {
    productId,
    productImage,
    productTitle,
    productCentsBasePrice,
    color,
    addons,
  };
}

// ************* DATA MODEL TRANSFORMS ******************* //
// ******************************************************* //
function generateDefaultCode(length) {
  const code = [];
  for (let i = 0; i < length; i += 1) {
    code.push('*');
  }
  return code;
}

function computeLayerCode(url, sentinel, length = 4) {
  // [ID]-base-??
  // Example "1038-base-01.png"
  // We want to parse this and have computed a code for each file name
  // 1038-base-01.png will create [1, 1, *, *]
  // 1038-base-23.png will create [*, *, 1, 1]
  // 1038-base.png will create    [*, *, *, *]
  const defaultCode = generateDefaultCode(length);
  const filename = url.substring(url.lastIndexOf('/') + 1);
  const rgxp = new RegExp(`${sentinel}-(.*).png`, 'g');
  const matches = rgxp.exec(filename);

  if (matches && matches[1]) {
    matches[1].split('').forEach(i => defaultCode[i] = '1');
  }
  return defaultCode;
}

export function transformAddons(productJSON) {
  const addons = productJSON.product.available_options.table.addons;
  const allCustomizations = productJSON.product.available_options.table.customizations.table.all;

  if (addons) { // NEW CAD SYSTEM, We have layers to our cads
    return assign({}, {
      // Marry previous customizations to addons
      addonLayerImages: addons.layer_images,
      selectedAddonImageLayers: [],
      addonOptions: allCustomizations.map(
        (ao, i) => {
          const mappedImageLayer = addons.layer_images.find(img => (img.bit_array[i] ? img : null));
          return assign({}, {
            id: ao.table.id,
            description: ao.table.name,
            position: mappedImageLayer ? mappedImageLayer.position : '',
            price: ao.table.display_price,
            centsTotal: parseInt(ao.table.display_price.money.fractional, 10),
            img: mappedImageLayer ? mappedImageLayer.url : '',
            active: false,
          });
        },
      ),
      baseImages: addons.base_images,
      baseSelected: null,
      addonsLayersComputed: addons.layer_images.map(({ url }) => computeLayerCode(url, 'layer')),
      addonsBasesComputed: addons.base_images.map(({ url }) => computeLayerCode(url, 'base')),
    });
  }

  return {
    // Building LegacyCADS in the same manner
    isLegacyCADCustomizations: true,
    addonOptions: allCustomizations.map(ao => assign({}, {
      id: ao.table.id,
      description: ao.table.name,
      position: ao.table.position,
      price: ao.table.display_price,
      centsTotal: parseInt(ao.table.display_price.money.fractional, 10),
      img: ao.table.image,
    })),
  };
}

export function transformProductCentsBasePrice({ prices = {} }) {
  // "original_amount": String,
  //   ****** into ******
  // productCentsBasePrice: Number
  // })
  const productCentsBasePrice = parseInt(prices.original_amount, 10) * 100;
  return productCentsBasePrice;
}

export function transformProductCurrency({ prices = {} }) {
  // "currency": String,
  //   ****** into ******
  // currency: String
  // })
  return prices.currency;
}

export function transformProductComplementaryProducts() {
  // UNKNOWN
  //   ****** into ******
  // centsPrice: Number,
  // smallImg: String,
  // productId: String,
  // productTitle: String,
  // url: String,
  // })
  console.warn('NEED BACKEND COMPLEMENTARY PRODUCTS');
  const complementaryProducts = [
    {
      centsPrice: 22900,
      smallImg: 'https://d1msb7dh8kb0o9.cloudfront.net/spree/products/37492/original/fprv1060-white-front.jpg?1499455161',
      productId: 'fprv1060',
      productTitle: 'The Laurel Dress',
      url: 'https://www.fameandpartners.com/dresses/dress-the-laurel-dress-1599?color=white',
    },
    {
      centsPrice: 26900,
      smallImg: 'https://d1msb7dh8kb0o9.cloudfront.net/spree/products/37428/original/fp2556-white-front.jpg?1499455106',
      productId: 'fp2556',
      productTitle: 'The Janette Dress',
      url: 'https://www.fameandpartners.com/dresses/dress-the-janette-dress-1598?color=white',
    },
  ];
  return complementaryProducts;
}

export function transformProductDescription({ description }) {
  // "description": String,
  //   ****** into ******
  // productDescription: String
  // })
  const productDescription = description;
  return productDescription;
}

export function transformProductDefaultColors({ colors = {} }) {
  console.warn('NEED A WAY TO RECIVE patternUrl');
  const defaultColors = colors.table.default || [];
  // "created_at": String,
  // "id": Number,
  // "image_content_type": null,
  // "image_file_name": null,
  // "image_file_size": null,
  // "name": String,
  // "option_type_id": Number,
  // "position": Number,
  // "presentation": String,
  // "updated_at": String,
  // "use_in_customisation": Boolean,
  // "value": String
  //   ****** into ******
  // ArrayOf({
  //   id: Number,
  //   name: String,
  //   presentation: String,
  //   hexValue: String,
  //   patternUrl: String,
  // })
  return defaultColors.map((c) => {
    const optionValue = c.option_value;
    return {
      id: optionValue.id,
      name: optionValue.name,
      presentation: optionValue.presentation,
      hexValue: optionValue.value,
      patternUrl: 'this-does-not-exist-yet.png',
    };
  });
}

export function transformProductSecondaryColors({ colors = {} }) {
  const secondaryColors = colors.table.extra || [];
  // "created_at": String,
  // "id": Number,
  // "image_content_type": null,
  // "image_file_name": null,
  // "image_file_size": null,
  // "name": String,
  // "option_type_id": Number,
  // "position": Number,
  // "presentation": String,
  // "updated_at": String,
  // "use_in_customisation": Boolean,
  // "value": String
  //   ****** into ******
  // ArrayOf({
  //   id: Number,
  //   name: String,
  //   presentation: String,
  //   hexValue: String,
  //   patternUrl: String,
  // })
  return secondaryColors.map((c) => {
    const optionValue = c.option_value;
    return {
      id: optionValue.id,
      name: optionValue.name,
      presentation: optionValue.presentation,
      hexValue: optionValue.value,
      patternUrl: 'this-does-not-exist-yet.png',
    };
  });
}

export function transformProductSecondaryColorsCentsPrice({ colors = {} }) {
  const extraPrice = colors.table.default_extra_price.price || {};
  // amount: String,
  // currency: String,
  // id: Number|Null
  // variant_id: Number|Null
  //   ****** into ******
  // productSecondaryColorsCentsPrice: Number
  const productSecondaryColorsCentsPrice = parseInt(extraPrice.amount, 10) * 100;
  return productSecondaryColorsCentsPrice;
}

export function transformProductFabric({ fabric }) {
  console.warn('NEED BACKEND FABRIC IMG');
  //   "fabric": String,
  //   ****** into ******
  //   {
  //    id: Number,
  //    img: String,
  //    name: String,
  //    description: String,
  //   }
  return {
    id: 'does-not-exist-yet',
    img: 'does-not-exist-yet.png',
    name: 'does-not-exist-yet',
    description: fabric,
  };
}

export function transformProductGarmentInformation() {
  //   "garment_care": null, // CURRENTLY NOT PASSED
  //   ****** into ******
  //   garmentCareInformation: String
  return 'Professional dry-clean only.\nSee label for further details.';
}

export function transformProductId({ id = 'dress-id' }) {
  //   "id": Number,
  //   ****** into ******
  //   id: Number,
  return id;
}

export function transformProductImages(images) {
  //   "id": Number,
  //   "url": String,
  //   "url_product": String,
  //   "color_id": 25,
  //   "height": Number,
  //   "width": Number,
  //   "alt": String
  //   ****** into ******
  //   id: Number,
  //   colorId: Number,
  //   smallImg: String,
  //   bigImg: String
  //   height: Number
  //   width: Number
  //   position: Number
  return images.map(i => ({
    id: i.id,
    colorId: i.color_id,
    smallImg: i.url_product,
    bigImg: i.url,
    height: i.height,
    width: i.width,
    position: i.position,
  }));
}

export function transformProductPreCustomizations() {
  console.warn('NEED BACKEND PRECUSTOMIZATIONS');
  //   UNKNOWN: Will need data from backend
  //   ****** into ******
  //   preCustomizations: arrayOf({
  //     id: Number|String,
  //     smallImg: String,
  //     description: String,
  //     selectedCustomizations: String (Potentially URL)
  //   })
  const preCustomizations = [
    {
      id: 'a0',
      smallImg: 'bs.co/a0.jpg',
      description: 'For cocktail',
      selectedCustomizations: {},
    },
    {
      id: 'a1',
      smallImg: 'bs.co/a1.jpg',
      description: 'For office',
      selectedCustomizations: {},
    },
    {
      id: 'a2',
      smallImg: 'bs.co/a2.jpg',
      description: 'For day',
      selectedCustomizations: {},
    },
  ];
  return preCustomizations;
}

export function transformProductModelDescription({ fit }) {
  //   "fit": String,
  //   ****** into ******
  //   modelDescription: String,
  const modelDescription = fit;
  return modelDescription;
}

export function transformProductTitle({ name }) {
  //   "name": Number,
  //   ****** into ******
  //   title: String,
  const title = name;
  return title;
}

export function transformProductSizeChart({ sizeChart }) {
  const sizes = sizeChart;
  return sizes;
}

export function transformProductJSON(productJSON) {
  const productState = {
    currency: transformProductCurrency(productJSON.product),
    complementaryProducts: transformProductComplementaryProducts(),
    fabric: transformProductFabric(productJSON.product),
    garmentCareInformation: transformProductGarmentInformation(),
    preCustomizations: transformProductPreCustomizations(),
    productCentsBasePrice: transformProductCentsBasePrice(productJSON.product),
    productDescription: transformProductDescription(productJSON.product),
    productDefaultColors: transformProductDefaultColors(productJSON.product),
    productSecondaryColors: transformProductSecondaryColors(productJSON.product),
    productSecondaryColorsCentsPrice: transformProductSecondaryColorsCentsPrice(productJSON.product),
    productId: transformProductId(productJSON.product),
    productImages: transformProductImages(productJSON.images),
    modelDescription: transformProductModelDescription(productJSON.product),
    productTitle: transformProductTitle(productJSON.product),
    sizeChart: transformProductSizeChart(productJSON),
  };

  const customizationState = {
    addons: transformAddons(productJSON),
    selectedColor: productState.productDefaultColors[0],
    temporaryColor: productState.productDefaultColors[0],
  };

  return {
    $$productState: productState,
    $$customizationState: customizationState,
  };
}

export default {
  addonSelectionDisplayText,
  calculateSubTotal,
  sizingDisplayText,
  reduceCustomizationSelectionPrice,
  // Transforms
  transformAddons,
  transformProductCentsBasePrice,
  transformProductComplementaryProducts,
  transformProductCurrency,
  transformProductDefaultColors,
  transformProductDescription,
  transformProductSecondaryColors,
  transformProductSecondaryColorsCentsPrice,
  transformProductFabric,
  transformProductGarmentInformation,
  transformProductId,
  transformProductImages,
  transformProductPreCustomizations,
  transformProductModelDescription,
  transformProductTitle,
  transformProductJSON,
};
