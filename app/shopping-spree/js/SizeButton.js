/* eslint-disable */

import React from 'react';
import PropTypes from 'prop-types';

export default class SizeButton extends React.Component
{
    render()
    {
        return (
            <div onClick={() => this.props.selectionCallback( this.props.size )} className={"size-box" + (this.props.selectedSize === this.props.size ? ' selected' : '') }>
              <div className="size-inner">US {this.props.size}</div>
            </div>
        );

    }
}

SizeButton.propTypes = {
    size: PropTypes.string.isRequired,
    selectedSize: PropTypes.string,
    selectionCallback: PropTypes.func.isRequired
};
