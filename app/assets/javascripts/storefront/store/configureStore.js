import { createStore, applyMiddleware } from 'redux';
import { assign } from 'lodash';
import { composeWithDevTools } from 'redux-devtools-extension';
import rootReducer from '../reducers';

function generateBaseCode(length) {
  const code = [];
  for (let i = 0; i <= length; i += 1) {
    code.push('*');
  }
  return code;
}

export default function configureStore(initialState) {
  console.log('initialState', initialState);
  const siteVersion = initialState.siteVersion.toLowerCase();
  initialState = assign({}, initialState,
    {
      lengths: [
        {
          value: 'petite',
          presentation_1: 'Smaller than',
          presentation_2: '167cm / 5\' 7\"',
        },
        {
          value: 'standard',
          presentation_1: 'Between 168cm / 5\' 7\" and 174cm / 5\' 10\"',
          presentation_2: ' ',
        },
        {
          value: 'tall',
          presentation_1: 'Taller than',
          presentation_2: '175cm / 5\' 10\"',
        },
      ],
    },
    {
      skirts: [
        {
          type: 'Mini',
          heights: [
            { type: 'Petite', cm: '42.5', inches: '16 ¾', },
            { type: 'Standard', cm: '45', inches: '17 ½', },
            { type: 'Tall', cm: '47.5', inches: '18 ¾', },
          ],
        },
        {
          type: 'Knee',
          heights: [
            { type: 'Petite', cm: '54', inches: '21 ¼', },
            { type: 'Standard', cm: '57', inches: '22 ½', },
            { type: 'Tall', cm: '60', inches: '23 ¾', },
          ],
        },
        {
          type: 'Petti',
          heights: [
            { type: 'Petite', cm: '68', inches: '26 ¾', },
            { type: 'Standard', cm: '72', inches: '28 ¼', },
            { type: 'Tall', cm: '76', inches: '29 ¾', },
          ],
        },
        {
          type: 'Midi',
          heights: [
            { type: 'Petite', cm: '75', inches: '29 ½', },
            { type: 'Standard', cm: '80', inches: '31 ½', },
            { type: 'Tall', cm: '85', inches: '33 ½', },
          ],
        },
        {
          type: 'Ankle',
          heights: [
            { type: 'Petite', cm: '94', inches: '37', },
            { type: 'Standard', cm: '99', inches: '39', },
            { type: 'Tall', cm: '104', inches: '41', },
          ],
        },
        {
          type: 'Maxi',
          heights: [
            { type: 'Petite', cm: '104', inches: '41', },
            { type: 'Standard', cm: '110', inches: '43 ¼', },
            { type: 'Tall', cm: '116', inches: '45 ½', },
          ],
        },
      ],
    },
    {
      customize: {
        addToBagPending: false,
        drawerOpen: null,
        errors: {},
        size: {
          id: null,
          presentation: '',
          error: false,
          message: '',
        },
        height: {
          temporaryHeightId: null,
          temporaryHeightValue: undefined,
          temporaryHeightUnit: siteVersion === 'au' || siteVersion === 'australia' ? 'cm' : 'inch',
          heightId: null,
          heightValue: undefined,
          heightUnit: siteVersion === 'au' || siteVersion === 'australia' ? 'cm' : 'inch',
        },
        color: {
          id: null,
          presentation: '',
          name: '',
          price: 0,
        },
        customization: {
          id: null,
          presentation: '',
          price: 0,
        },
        dressVariantId: null,
        makingOption: {
          id: null,
          price: 0,
        },
      },
    },
    // Unfortunately, old code does not take into account the concept of hydration,
    // which does not work great on deep nesting. The ugly code below is a workaround
    // to allow a computed property to be added to a state tree
    initialState.addons.empty ? {} :
    { addons: assign({}, initialState.addons, {
      addonsBasesComputed: initialState.addons.bases.map((base) => {
        // [ID]-base-??
        // Example "1038-base-01.png"
        // We want to parse this and have computed a code for each file name
        // 1038-base-01.png will create [1, 1, *, *]
        // 1038-base-23.png will create [*, *, 2, 3]
        // 1038-base.png will create    [*, *, *, *]
        const baseCode = generateBaseCode(initialState.addons.bases.length);
        const filename = base.substring(base.lastIndexOf('/') + 1);
        const rgxp = /base-(.*).png/g;
        const matches = rgxp.exec(filename);

        if (matches && matches[1]) {
          matches[1].split('').forEach(i => baseCode[i] = '1');
        }
        console.log('baseCode', baseCode);
        return baseCode;
      }),
    }) },
  );

  if (process.env.NODE_ENV === 'development') {
    const reduxImmutableStateInvariant = require('redux-immutable-state-invariant')();
    return createStore(rootReducer, initialState, composeWithDevTools(applyMiddleware(reduxImmutableStateInvariant)));
  }
  return createStore(rootReducer, initialState);
}
