import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';
import autoBind from 'react-autobind';
import classnames from 'classnames';
import fabricImg from '../../../img/test/fabric.png';
import ProductFabricInfo from './ProductFabricInfo';

// CSS
import '../../../css/components/ProductFabric.scss';

/* eslint-disable react/prefer-stateless-function */
class ProductFabric extends PureComponent {
  constructor(props) {
    super(props);
    autoBind(this);
  }

  handleFabricInfoClick() {
    const {
      breakpoint,
      handleFabricInfoModalClick,
    } = this.props;

    if (breakpoint === 'mobile') { handleFabricInfoModalClick(); }
  }

  render() {
    const {
      fabric,
      garmentCareInformation,
    } = this.props;
    return (
      <div
        className="ProductFabric u-position--relative u-height--full"
        style={{ background: `url(${fabricImg})` }}
      >
        <div
          className={classnames(
            'ProductFabric__contents u-width--full',
            'u-position--absolute u-text-align--center',
          )}
        >

          <ProductFabricInfo
            className="textAlign--left"
            fabric={fabric}
            garmentCareInformation={garmentCareInformation}
          />

          <span
            className="u-underline"
            onClick={this.handleFabricInfoClick}
          >
              View Fabric Info
          </span>
        </div>

      </div>
    );
  }
}

ProductFabric.propTypes = {
  breakpoint: PropTypes.string.isRequired,
  fabric: PropTypes.shape({
    id: PropTypes.string,
    smallImg: PropTypes.string,
    name: PropTypes.string,
    description: PropTypes.string,
  }).isRequired,
  garmentCareInformation: PropTypes.string.isRequired,
  handleFabricInfoModalClick: PropTypes.func.isRequired,
};
ProductFabric.defaultProps = {};

export default ProductFabric;
