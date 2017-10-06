import React from 'react';
import * as firebase from 'firebase';
import autoBind from 'react-autobind';
import PropTypes from 'prop-types';
import FirebaseComponent from './FirebaseComponent';
import SizeButton from './SizeButton';

export default class AddToCartModal extends FirebaseComponent {

  constructor(props) {
    super(props);
    autoBind(this);
    this.state = {
      selectedSize: null,
      height: null,
      showHeightError: false,
      showSizeError: null,
    };
    this.initializeFirebase();
  }


  addToCart() {
    if (this.state.height == null) {
      this.setState(
        {
          showHeightError: true,
        },
            );
    }

    if (this.state.selectedSize == null) {
      this.setState(
        {
          showSizeError: true,
        },
            );
    }

    if (this.state.height && this.state.selectedSize) {
      this.createFirebaseCartItem();
      this.createFirebaseFamebotMessage();

      this.props.closeModal();
    }
  }

  sumCartData(snapshot) {
    const data = snapshot.val();
    const keys = Object.keys(data);
    let cartTotal = 0;
    for (let i = 0; i < keys.length; i += 1) {
      const dress = data[keys[i]];
      cartTotal += parseInt(dress.dress.price, 10);
    }

    this.createFamebotMessage(`${this.props.name} just added ${this.props.dress.name} to their cart.  You are now getting ${this.calculateDiscount(cartTotal)}% off`);
  }

  createFirebaseFamebotMessage() {
    this.databaseRef('cart').once('value').then(this.sumCartData);
  }

  createFirebaseCartItem() {
    const newMessage = this.cartDB.push();
    console.log(this.props.dress);
    newMessage.set({ created_at: firebase.database.ServerValue.TIMESTAMP,
      dress:
      {
        size: this.state.selectedSize,
        height: this.state.height,
        description: this.props.dress.description,
        image: this.props.dress.image,
        name: this.props.dress.name,
        price: this.props.dress.price,
        product_id: this.props.dress.product_id,
        url: this.props.dress.url,
      },
      entry_for:
      {
        name: this.props.name,
        email: this.props.email,
        icon: this.props.icon,
      },
    },
                      );
  }

  initializeFirebase() {
    super.connectToFirebase();
    this.cartDB = this.databaseRef('cart');
  }

  heightSelected(event) {
    this.setState({ height: event.target.value });
  }
  sizeSelected(size) {
    this.setState({ selectedSize: size });
  }

  generateSizeRow(startSize, endSize) {
    const sizeRows = [];
    for (let i = startSize; i <= endSize; i += 2) {
      sizeRows.push(
        <SizeButton
          key={i.toString()}
          size={i.toString()}
          selectedSize={this.state.selectedSize}
          selectionCallback={this.sizeSelected}
        />);
    }

    for (let i = sizeRows.length; i < 5; i += 1) {
      sizeRows.push(<div key={endSize + i} className="size-box-hidden" />);
    }

    return (<div className="row">
      <div className="col-xs-8 col-xs-push-1">
        <div className="size-row">{sizeRows}</div>
      </div>
    </div>
    );
  }

  render() {
    return (
      <div>
        <div className="shopping-spree-share-modal-background shopping-spree" />
        <div className="shopping-spree-cart-modal shopping-spree">
          <span className="btn-close med" alt="Close" onClick={this.props.closeModal} />
          <div className="row">
            <div
              id="add-to-cart-headline"
              className="col-xs-12 text-center shopping-spree-big-headline"
            >
              Add to your cart!
            </div>
          </div>

          <div className="row modal-sub-headline">
            <div className="col-xs-12 text-center">
                    Just tell us your height and size, and
                  </div>
          </div>

          <div className="row">
            <div className="col-xs-12 text-center">
                    we'll take care of your tailoring.
                  </div>
          </div>

          <div className="row height-select-text">
            <div className="col-xs-11 col-xs-push-1">
                    What's your Height?
                  </div>
          </div>

          <div className="row">
            <div className="col-xs-8 col-md-6 col-xs-push-1">
              <select onChange={this.heightSelected} className={this.state.showHeightError ? 'height-select red-border' : 'height-select'}>
                <option disabled selected value>Select</option>
                <option value="58">4ft 10in</option>
                <option value="59">4ft 11in</option>
                <option value="60">5ft 0in</option>
                <option value="61">5ft 1in</option>
                <option value="62">5ft 2in</option>
                <option value="63">5ft 3in</option>
                <option value="64">5ft 4in</option>
                <option value="65">5ft 5in</option>
                <option value="66">5ft 6in</option>
                <option value="67">5ft 7in</option>
                <option value="68">5ft 8in</option>
                <option value="69">5ft 9in</option>
                <option value="70">5ft 10in</option>
                <option value="71">5ft 11in</option>
                <option value="72">6ft 0in</option>
                <option value="73">6ft 1in</option>
                <option value="74">6ft 2in</option>
                <option value="75">6ft 3in</option>
                <option value="76">6ft 4in</option>
              </select>
            </div>
          </div>
          {
            this.state.showHeightError &&
            <div className="row">
              <div
                className="col-xs-11 col-xs-push-1 shopping-spree-error"
              >
                  Please select your height
              </div>
            </div>
          }
          <div className="row height-select-text">
            <div className="col-xs-11 col-xs-push-1">
              What's Your Dress Size?
            </div>
          </div>
          { this.generateSizeRow(0, 8) }
          { this.generateSizeRow(10, 18) }
          { this.generateSizeRow(20, 26) }
          {
          this.state.showSizeError &&
            <div className="row">
              <div
                className="col-xs-11 col-xs-push-1 shopping-spree-error"
              >
                Please select your size
              </div>
            </div>
          }

          <div className="row">
            <div className="col-xs-11 col-xs-push-1">
              <a
                className="shopping-spree-link"
                href="https://www.fameandpartners.com/size-guide"
                target="_blank"
                rel="noopener noreferrer"
              >
                  View Sizing Guide
                </a>
            </div>
          </div>
          <div className="row add-to-cart-button">
            <div className="col-xs-10 col-xs-push-1">
              <a
                onClick={this.addToCart}
                className="btn btn-lrg btn-black btn-block"
              >
                Add to your cart</a>
            </div>
          </div>
        </div>
      </div>
    );
  }
}

AddToCartModal.propTypes = {
  firebaseAPI: PropTypes.string.isRequired,
  firebaseDatabase: PropTypes.string.isRequired,
  name: PropTypes.string,
  icon: PropTypes.number,
  email: PropTypes.string,
  firebaseId: PropTypes.string,
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
  ),
  closeModal: PropTypes.func.isRequired,
};

AddToCartModal.defaultProps = {
  dress: PropTypes.shape(
    {
      image: 'test',
      name: 'test',
      url: 'test',
      fabric: 'test',
      length: 'test',
      price: 'test',
      size: 'test',
    },
  ),
};
