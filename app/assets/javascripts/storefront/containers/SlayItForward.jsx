import React, { PropTypes } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
// import Immutable from 'immutable';
// import * as templateActionCreators from '../actions/templateActionCreators';

function select(state) {
  // Which part of the Redux global state does our component want to receive as props?
  // Note the use of `$$` to prefix the property name because the value is of type Immutable.js
  // return { $$templateStore: state.$$templateStore };
  return {};
}

// Simple example of a React "smart" component
const SlayItForward = (props) => {
  // const { dispatch, $$templateStore } = props;
  const { dispatch } = props;
  const actions = bindActionCreators(templateActionCreators, dispatch);
  // const { updateName } = actions;
  // const name = $$templateStore.get('name');

  // This uses the ES2015 spread operator to pass properties as it is more DRY
  // This is equivalent to:
  // <SlayItForwardWidget $$templateStore={$$templateStore} actions={actions} />
  return (
    <div>
      Slay it forward containers
    </div>
  );
};

// SlayItForward.propTypes = {
//   dispatch: PropTypes.func.isRequired,
//
//   // This corresponds to the value used in function select above.
//   // We prefix all property and variable names pointing to Immutable.js objects with '$$'.
//   // This allows us to immediately know we don't call $$templateStore['someProperty'], but
//   // instead use the Immutable.js `get` API for Immutable.Map
//   $$templateStore: PropTypes.instanceOf(Immutable.Map).isRequired,
// };

// Don't forget to actually use connect!
// Note that we don't export SlayItForward, but the redux "connected" version of it.
// See https://github.com/reactjs/react-redux/blob/master/docs/api.md#examples
export default connect(select)(Template);
