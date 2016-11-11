import {createStore, applyMiddleware} from 'redux';
import rootReducer from '../reducers';
import reduxImmutableStateInvariant from 'redux-immutable-state-invariant';

export default function configureStore(initialState) {
  initialState = Object.assign({}, initialState,
    {
      lengths: [
        {
          value: 'petite',
          presentation_1: 'Smaller than',
          presentation_2: '167cm / 5\' 7\"'
        },
        {
          value: 'standard',
          presentation_1: 'Between 168cm / 5\' 7\" and 174cm / 5\' 10\"',
          presentation_2: ' '
        },
        {
          value: 'tall',
          presentation_1: 'Taller than',
          presentation_2: '175cm / 5\' 10\"'
        }
      ]
    },
    {
      skirts: [
        {
          type: 'Mini',
          heights: [
            {type: 'Petite',   cm: '42.5', inches: '16 ¾'},
            {type: 'Standard', cm: '45',   inches: '17 ½'},
            {type: 'Tall',     cm: '47.5', inches: '18 ¾'}
          ]
        },
        {
          type: 'Knee',
          heights: [
            {type: 'Petite',   cm: '54', inches: '21 ¼'},
            {type: 'Standard', cm: '57', inches: '22 ½'},
            {type: 'Tall',     cm: '60', inches: '23 ¾'}
          ]
        },
        {
          type: 'Petti',
          heights: [
            {type: 'Petite',   cm: '68', inches: '26 ¾'},
            {type: 'Standard', cm: '72', inches: '28 ¼'},
            {type: 'Tall',     cm: '76', inches: '29 ¾'}
          ]
        },
        {
          type: 'Midi',
          heights: [
            {type: 'Petite',   cm: '75', inches: '29 ½'},
            {type: 'Standard', cm: '80', inches: '31 ½'},
            {type: 'Tall',     cm: '85', inches: '33 ½'}
          ]
        },
        {
          type: 'Ankle',
          heights: [
            {type: 'Petite',   cm: '94',  inches: '37'},
            {type: 'Standard', cm: '99',  inches: '39'},
            {type: 'Tall',     cm: '104', inches: '41'}
          ]
        },
        {
          type: 'Maxi',
          heights: [
            {type: 'Petite',   cm: '104', inches: '41'},
            {type: 'Standard', cm: '110', inches: '43 ¼'},
            {type: 'Tall',     cm: '116', inches: '45 ½'}
          ]
        }
      ]
    },
    {
      customize: {
        size: {
          id: null,
          presentation: '',
          error: false,
          message: ''
        },
        length: {
          id: null,
          presentation: '',
          error: false,
          message: ''
        },
        color: {
          id: null,
          presentation: '',
          name: '',
          price: 0
        },
        customization: {
          id: null,
          presentation: '',
          price: 0
        },
        dressVariantId : null,
        makingOptionId : null
      }
    }
  );

  return createStore(
    rootReducer,
    initialState,
    applyMiddleware(reduxImmutableStateInvariant())
  );
}
