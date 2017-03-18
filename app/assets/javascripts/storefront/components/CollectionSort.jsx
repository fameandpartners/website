import React, {Component, PropTypes} from 'react';
import {connect,} from 'react-redux';
import {bindActionCreators,} from 'redux';
import * as CollectionFilterSortActions from '../actions/CollectionFilterSortActions';
import Select from './shared/Select.jsx';

function stateToProps(state, props) {
    // Which part of the Redux global state does our component want to receive as props?
    if (state.$$collectionFilterSortStore) {
        const collectionFilterSortStore = state.$$collectionFilterSortStore.toJS();
        return { order: collectionFilterSortStore.order, };
    }
    return {};
}
function dispatchToProps(dispatch){
  return bindActionCreators(CollectionFilterSortActions, dispatch);
}

class CollectionSort extends Component {
    constructor(props) {
        super(props);
        console.log('props within CollectionSort', props);
    }

    handleSelection(selection) {
      return () => {
        console.log('clicking selection!', selection);
      }
    }

    generateOptions() {
      return [
        {id: 0, name: 'Option One', active: false},
        {id: 1, name: 'Option Two', active: false}
      ];
    }

    render() {
      const {order} = this.props;
      return (
        <div className="checkboxBlackBg">
          <label className="ExpandablePanel__option" name="price_high">
            <Select
              id='colletion-sort-options'
              onChange={()=>{}}
              label='Sort'
              className='sort-options'
              options={this.generateOptions()}
            />
            <input
              id="price_high"
              name="price_high"
              type="checkbox"
              value="true"
              checked={order === 'price_high'}
            />
          </label>
          <label className="ExpandablePanel__option" name="price_low">
            <input
              id="price_low"
              name="price_low"
              type="checkbox"
              value="true"
              checked={order === 'price_low'}
            />
          </label>
          <label className="ExpandablePanel__option" name="newest">
            <input
              id="newest"
              name="newest"
              type="checkbox"
              value="true"
              checked={order === 'newest'}
            />
          </label>
        </div>
      );
    }
}

CollectionSort.propTypes = {};

export default connect(stateToProps, dispatchToProps)(CollectionSort);
