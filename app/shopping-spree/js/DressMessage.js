import React from 'react';
import PropTypes from 'prop-types';

export default class DressMessage extends React.Component {
  constructor(props) {
    super(props);
    let customization = null;
    const { dress } = this.props;
    if (dress.customizations) {
      customization = dress.customizations.presentation;
    }
    this.state = {
      customization,
    };
    this.renderCustomizations = this.renderCustomizations.bind(this);
  }

  renderCustomizations() {
    if (this.state.customization && this.state.customization !== '') {
      return (
        <div>
          <div className="row">
            <div className={'col-xs-4'}>
                Customizations:
              </div>
          </div>
          <div className="row">
            <div className="col-xs-12">{this.state.customization}</div>
          </div>
        </div>
      );
    }
    return (<div />);
  }

  render() {
    const { sameOwnerAsLastMessage, iconNumber, dress, showAddToCartModal } = this.props;
    const sameOwner = sameOwnerAsLastMessage;
    let name = '';
    if (!sameOwner) {
      name = (
        <div className="row equal">
          <div className="message-name col-xs-push-2 col-xs-10">
            {name}
          </div>
        </div>
      );
    }

    return (
      <li className="dress-message">
        {name}
        <div className="row equal">
          <div className={`avatar col-xs-2 ${sameOwnerAsLastMessage ? '' : `avatar-${iconNumber}`}`} />
          <div className="dress-card col-xs-6">
            <div className="dress-card-content">
              <div className="row">
                <div className="dress-card-image col-xs-12">
                  <img alt={dress.name} src={dress.image} />
                </div>
              </div>
              <div className="row dress-card-headline">
                <div className="col-xs-8">
                  {dress.name}
                </div>
                <div className="dress-price col-xs-4">
                  ${parseInt(dress.price, 10)}
                </div>
              </div>
              <div className="row">
                <div className={'col-xs-4'}>
                  Color
                </div>
                <div className={`col-xs-4 dress-color swatch color-${dress.color.name}`} />
              </div>
              { this.renderCustomizations() }
              <div className="row add-to-spree-btn">
                <div className="col-xs-12">
                  <a
                    onClick={() => showAddToCartModal(dress)}
                    className="center-block btn btn-black btn-lrg"
                  >
                    Add to my cart
                  </a>
                </div>
              </div>
            </div>
          </div>
        </div>
      </li>
    );
  }
}

DressMessage.propTypes =
{
  sameOwnerAsLastMessage: PropTypes.bool.isRequired,
  iconNumber: PropTypes.number.isRequired,
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
  showAddToCartModal: PropTypes.func.isRequired,
};
