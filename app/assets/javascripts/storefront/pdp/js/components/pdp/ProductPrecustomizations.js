import React, { Component } from 'react';
import PropTypes from 'prop-types';
import autoBind from 'react-autobind';
import { connect } from 'react-redux';
// import { bindActionCreators } from 'redux';

// Actions
// import * as AppActions from '../../actions/AppActions';

// CSS
// import '../../../css/components/ProductPrecustomizations.scss';


function stateToProps(state) {
  // Which part of the Redux global state does our component want to receive as props?
  return {
    preCustomizations: state.$$productState.get('preCustomizations').toJS(),
  };
}


class ProductPrecustomizations extends Component {
  constructor(props) {
    super(props);
    autoBind(this);
  }

  render() {
    const { preCustomizations } = this.props;

    return (
      <div className="ProductPrecustomizations typography">
        <h5>Other versions</h5>

        <div className="grid-12">
          { preCustomizations.map(pc => (
            <div key={`pc-${pc.id}`} className="ProductPrecustomizations__product-wrapper col-4">
              <img className="u-width--full" alt={`Customize it ${pc.description}`} src={pc.smallImg} />
              <span className="link--static">{pc.description}</span>
            </div>
          ))}
        </div>
      </div>
    );
  }
}

ProductPrecustomizations.propTypes = {
  preCustomizations: PropTypes.arrayOf(
    PropTypes.shape({
      id: PropTypes.string,
      smallImg: PropTypes.string,
      description: PropTypes.string,
      selectedCustomizations: PropTypes.obj,
    }),
  ).isRequired,
};

export default connect(stateToProps)(ProductPrecustomizations);
