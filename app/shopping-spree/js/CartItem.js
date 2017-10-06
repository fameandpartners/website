import React from 'react';
import PropTypes from 'prop-types';
import noop from './noop';


export default class CartItem extends React.Component {
  constructor(props) {
    super(props);

    this.deleteMe = this.deleteMe.bind(this);
  }

  deleteMe() {
    this.props.delete(this.props.firebaseKey);
  }

  render() {
    return (
      <li>
        <div className="row">
          <div className="col-xs-4 col-xs-push-1">
            <img src={this.props.dress.image} alt={this.props.dress.name} />
          </div>
          <div className="col-xs-4 col-xs-push-1">
            <div className="row">
              <strong>{this.props.dress.name} ${parseInt(this.props.dress.price, 10)}</strong>
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
            <span
              onClick={this.deleteMe}
              className="btn-close med" alt="Delete Item"
            />
          </div>
        </div>
      </li>);
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
      size: PropTypes.string.isRequired,
    },
    ).isRequired,
  delete: PropTypes.func,
  firebaseKey: PropTypes.string,
};


CartItem.defaultProps = {
  delete: noop,
  firebaseKey: 'AIzaSyDhbuF98kzK0KouFeasDELcOKJ4q7DzhHY',
};
