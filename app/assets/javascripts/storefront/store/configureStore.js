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
            {type: 'Petite',   cm: '42', inches: '16 ½'},
            {type: 'Standard', cm: '45', inches: '17 ¾'},
            {type: 'Tall',     cm: '48', inches: '19'}
          ]
        },
        {
          type: 'Knee',
          heights: [
            {type: 'Petite',   cm: '45.5', inches: '18'},
            {type: 'Standard', cm: '50',   inches: '19 ¾'},
            {type: 'Tall',     cm: '54.5', inches: '21 ½'}
          ]
        },
        {
          type: 'Petti',
          heights: [
            {type: 'Petite',   cm: '64', inches: '25'},
            {type: 'Standard', cm: '70', inches: '27 ½'},
            {type: 'Tall',     cm: '76', inches: '30'}
          ]
        },
        {
          type: 'Midi',
          heights: [
            {type: 'Petite',   cm: '72', inches: '28 ½'},
            {type: 'Standard', cm: '80', inches: '31 ½'},
            {type: 'Tall',     cm: '88', inches: '34 ½'}
          ]
        },
        {
          type: 'Maxi',
          heights: [
            {type: 'Petite',   cm: '102', inches: '40'},
            {type: 'Standard', cm: '112', inches: '44'},
            {type: 'Tall',     cm: '122', inches: '48'}
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
        dressVariantId : null
      }
    }
  );

  return createStore(
    rootReducer,
    initialState,
    applyMiddleware(reduxImmutableStateInvariant())
  );
}
