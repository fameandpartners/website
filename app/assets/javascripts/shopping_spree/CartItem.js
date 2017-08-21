import React from 'react';


export default class CartItem extends React.Component
{
    render()
    {
        return (
            <li>
              <div className="row">
                <div className="col-xs-4 col-xs-push-1">
                  <img src={this.props.dress.image} alt={this.props.dress.name}/>
                </div>
                <div className="col-xs-4 col-xs-push-1">
                  {this.props.dress.name}
                </div>
                <div className="col-xs-1 col-xs-push-1">
                  X
                </div>
              </div>
            </li> );
        
    }
}

 
CartItem.propTypes = {
    dress: React.PropTypes.shape(
        {
            image: React.PropTypes.string.isRequired,
            name: React.PropTypes.string.isRequired,
            url: React.PropTypes.string.isRequired
        }
    ).isRequired

}
