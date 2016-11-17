import React, { PropTypes } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import Immutable from 'immutable';
import * as slayActions from '../actions/SlayItForwardActions';

function select(state) {
  return state;
}

const SlayItForward = (props) => {
  const { dispatch, SlayItForwardState } = props;
  return (
    <div>
      Slay it forward containers
    </div>
  );
};

SlayItForward.propTypes = {
  dispatch: PropTypes.func.isRequired,
  SlayItForwardState: PropTypes.object
};

export default connect(select)(SlayItForward);
