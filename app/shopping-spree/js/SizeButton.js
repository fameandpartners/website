/* eslint-disable */
import React from 'react';
import PropTypes from 'prop-types';


const SizeButton = props => (
  <div onClick={() => props.selectionCallback(props.size)} className={`size-box${props.selectedSize === props.size ? ' selected' : ''}`}>
    <div className="size-inner">{props.size}</div>
  </div>
  );

SizeButton.propTypes = {
  size: React.PropTypes.string.isRequired,
  selectedSize: React.PropTypes.string,
  selectionCallback: React.PropTypes.func.isRequired,
};


export default SizeButton;
