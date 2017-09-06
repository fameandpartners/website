import React, { Component } from 'react';
import PropTypes from 'prop-types';
import autoBind from 'react-autobind';
import { connect } from 'react-redux';
import objnoop from '../../libs/objnoop';
// import { bindActionCreators } from 'redux';

// Actions
// import * as AppActions from '../../actions/AppActions';

// CSS
import '../../../css/components/ProductDescription.scss';


function stateToProps(state) {
  // Which part of the Redux global state does our component want to receive as props?
  return {
    productDescription: state.$$productState.get('productDescription'),
    modelDescription: state.$$productState.get('modelDescription'),
  };
}


class ProductDescription extends Component {
  constructor(props) {
    super(props);
    autoBind(this);
  }

  render() {
    const { productDescription, modelDescription } = this.props;
    return (
      <div className="ProductDescription u-center">
        <div dangerouslySetInnerHTML={{ __html: productDescription }} />
        <p>-</p>
        <p dangerouslySetInnerHTML={{ __html: modelDescription }} />
      </div>
    );
  }
}

ProductDescription.propTypes = {
  productDescription: PropTypes.string.isRequired,
  modelDescription: PropTypes.string.isRequired,
};

export default connect(stateToProps, objnoop)(ProductDescription);
