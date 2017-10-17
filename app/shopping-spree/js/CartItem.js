/* eslint-disable */

import React from 'react';
import PropTypes from 'prop-types';

export default class CartItem extends React.Component
{
    constructor( props )
    {
        super( props );

        this.deleteMe = this.deleteMe.bind(this);
    }

    deleteMe()
    {
        this.props.delete( this.props.firebaseKey );
    }

    render()
    {
        const { dress } = this.props;
        return (
            <li>
              <div className="row">
                <div className="col-xs-4 col-xs-push-1">
                  <img src={dress.image} alt={dress.name}/>
                </div>
                <div className="col-xs-4 col-xs-push-1">
                  <div className="row">
                    <strong>{dress.name} ${parseInt(dress.price)}</strong>
                  </div>
                  <div className="row">
                    Size: {Math.floor(parseInt(dress.height)/12)}ft {parseInt(dress.height)%12} / US {dress.size}
                  </div>
                </div>
                <div className="col-xs-1 col-xs-push-2">
                <a onClick={this.deleteMe} className="btn-close med" alt="Delete Item"></a>
                </div>
              </div>
            </li> );

    }
}


CartItem.propTypes = {
    dress: PropTypes.shape(
        {
            image: PropTypes.string.isRequired,
            name: PropTypes.string.isRequired,
            url: PropTypes.string.isRequired,
            fabric: PropTypes.string.isRequired,
            length: PropTypes.string.isRequired,
            price: PropTypes.string.isRequired,
            size: PropTypes.string.isRequired
        }
    ).isRequired

}
