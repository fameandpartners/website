import React from 'react';


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
        return (
            <li>
              <div className="row">
                <div className="col-xs-4 col-xs-push-1">
                  <img src={this.props.dress.image} alt={this.props.dress.name}/>
                </div>
                <div className="col-xs-4 col-xs-push-1">
                  <div className="row">
                    <strong>{this.props.dress.name} ${parseInt(this.props.dress.price)}</strong>
                  </div>
                  <div className="row">
                    {this.props.dress.fabric}
                  </div>
                  <div className="row">
                    {this.props.dress.length}
                  </div>
                  <div className="row">
                    {this.props.dress.size}
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
    dress: React.PropTypes.shape(
        {
            image: React.PropTypes.string.isRequired,
            name: React.PropTypes.string.isRequired,
            url: React.PropTypes.string.isRequired,
            fabric: React.PropTypes.string.isRequired,
            length: React.PropTypes.string.isRequired,
            price: React.PropTypes.string.isRequired,
            size: React.PropTypes.string.isRequired
        }
    ).isRequired

}
