import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';
import classnames from 'classnames';

/* eslint-disable react/prefer-stateless-function */
class ProductOptionsRow extends PureComponent {
  rightNodeElem() {
    const { rightNode, handleClick } = this.props;
    if (rightNode) return rightNode;
    if (typeof handleClick === 'function') {
      return (
        <span onClick={handleClick} className="link">Add</span>
      );
    }
    return null;
  }

  render() {
    const {
      leftNode,
      leftNodeClassName,
      rightNodeClassName,
      optionIsSelected,
      heading,
      rightNode,
      handleClick,
    } = this.props;

    return (
      <div
        className={classnames(
          'ProductOptionsRow',
          'ProductOptions__ProductOptionsRow',
          'grid-spaceBetween',
          {
            'ProductOptionsRow--heading': heading,
          },
        )}
        onClick={handleClick}
      >
        <span
          className={classnames(
            'ProductOptionsRow__left textAlign--left',
            leftNodeClassName,
          )}
        >
          {leftNode}
        </span>

        <span
          className={classnames(
            'ProductOptionsRow__right u-text-align--right',
            rightNodeClassName,
            {
              'ProductOptionsRow__right--fade-in': optionIsSelected || heading || rightNode,
              'ProductOptionsRow__right--selected': optionIsSelected,
            },
          )}
        >
          {this.rightNodeElem()}
        </span>
      </div>
    );
  }
}

ProductOptionsRow.propTypes = {
  leftNode: PropTypes.node,
  leftNodeClassName: PropTypes.string,
  rightNode: PropTypes.node,
  rightNodeClassName: PropTypes.string,
  heading: PropTypes.bool,
  optionIsSelected: PropTypes.bool,
  handleClick: PropTypes.func,
};

ProductOptionsRow.defaultProps = {
  leftNode: null,
  leftNodeClassName: '',
  rightNode: null,
  rightNodeClassName: '',
  optionIsSelected: false,
  heading: false,
  handleClick: null,
};

export default ProductOptionsRow;
