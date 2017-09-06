import { assign } from 'lodash';
import mirrorCreator from 'mirror-creator';

const actionTypes = assign({},
  mirrorCreator([
    'ACTIVATE_SIDE_MENU',
    'ACTIVATE_CART_DRAWER',
    'SET_SHAREABLE_QUERY_PARAMS',
  ]),
);

const queryParams = {
  QUERY_PARAMS: {
    color: 'clr',
    customizations: 'cus',
  },
};

const navigationContainers = {
  NAVIGATION_CONTAINERS: mirrorCreator([
    'SHOP_ALL',
    'WHO_WE_ARE',
  ]),
};

const navigationLinks = {
  NAVIGATION_LINKS: {
    WEDDINGS: [
      {
        text: 'Brides',
        url: '/bespoke-bridal-collection',
      },
      {
        text: 'Bridesmaids',
        url: '/modern-bridesmaid-dresses',
      },
      {
        text: 'Wedding Guests',
        url: '/dresses/wedding-guests',
      },
      {
        text: 'Bespoke Bridal',
        url: '/this-has-no-link',
      },
      {
        text: 'Bridal Style Guides',
        url: '/this-has-no-link',
      },
      {
        text: 'Summer Weddings',
        url: '/dresses/summer-weddings',
      },
      {
        text: 'Wedding Styling',
        url: '/wedding-consultation',
      },
      {
        text: 'The Wedding App',
        url: '/wedding-atelier',
      },
    ],
    DRESSES: [
      {
        text: 'Maxi Dresses',
        url: '/dresses/long',
      },
      {
        text: 'Midi Dresses',
        url: '/dresses/midi',
      },
      {
        text: 'Mini Dresses',
        url: '/dresses/mini',
      },
      {
        text: 'Cocktail',
        url: '/dresses/cocktail',
      },
      {
        text: 'Casual',
        url: '/dresses/casual',
      },
      {
        text: 'Evening',
        url: '/dresses/evening',
      },
      {
        text: 'Prom',
        url: '/dresses/prom',
      },
    ],
    SEPARATES: [
      {
        text: 'Tops',
        url: '/tops',
      },
      {
        text: 'Skirts',
        url: '/skirts',
      },
      {
        text: 'Pants',
        url: '/pants',
      },
      {
        text: 'Jumpsuits',
        url: '/dresses/jumpsuits',
      },
      {
        text: 'Outerwear',
        url: '/outerwear',
      },
    ],
    NEW_ARRIVALS: [
      {
        text: 'Best Sellers',
        url: '/bespoke-bridal-collection',
      },
      {
        text: 'Trending Looks',
        url: '/modern-bridesmaid-dresses',
      },
    ],
    COLLECTIONS: [
      {
        text: 'High Contrast',
        url: '/high-contrast',
      },
      {
        text: 'Modern Evening',
        url: '/the-modern-evening-collection',
      },
      {
        text: 'Pre-Season Evening',
        url: '/pre-season-evening-collection',
      },
      {
        text: 'Inside/Out',
        url: '/inside-out-collection',
      },
      {
        text: 'Anti Fast Fashion Shop',
        url: '/the-anti-fast-fashion-shop',
      },
    ],
    WHO_WE_ARE: [
      {
        text: 'About Us',
        url: '/about',
      },
      {
        text: 'Why Made to Order',
        url: '/why-us',
      },
      {
        text: 'Empowerment Initiatives',
        url: '/iequalchange',
      },
      {
        text: 'Read the Fame Files',
        url: 'http://blog.fameandpartners.com/',
      },
      {
        text: 'Join the Fame Society',
        url: '/fame-society-application',
      },
      {
        text: 'Meet the CEO',
        url: '/from-our-ceo',
      },
    ],
  },
};

const configuration = assign({},
  {
    ANIMATION_CONFIGURATION: {
      stiffness: 94,
      damping: 20,
      precision: 5,
    },
    ANIMATION_CONFIGURATION_SMOOTH: {
      stiffness: 100,
      damping: 29,
      precision: 8,
    },
  },
);

export default assign({},
  actionTypes,
  navigationContainers,
  navigationLinks,
  queryParams,
  configuration,
);
