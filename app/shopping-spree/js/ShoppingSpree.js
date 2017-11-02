/* eslint-disable */
import React from 'react';
import PropTypes from 'prop-types';
import Cookies from 'universal-cookie';
import Drawer from './Drawer';
import Onboarding from './Onboarding';
import ShareModal from './ShareModal';
import AddToCartModal from './AddToCartModal';
import win from './windowPolyfill';
import FirebaseComponent from './FirebaseComponent';
import Modal from 'react-modal';
import * as firebase from 'firebase';
import _ from 'lodash';

import { ToastContainer, toast } from 'react-toastify';

export default class ShoppingSpree extends FirebaseComponent {
  constructor(props) {
    super(props);
    this.cookies = new Cookies();

    this.doneOnboarding = this.doneOnboarding.bind(this);
    this.doneSharing = this.doneSharing.bind(this);
    this.deleteAllItemsFromMyCart = this.deleteAllItemsFromMyCart.bind(this);
    this.showAddToCartModal = this.showAddToCartModal.bind(this);
    this.closeAddToCartModal = this.closeAddToCartModal.bind(this);
    this.changeDisplayStatus = this.changeDisplayStatus.bind(this);
    this.doneShoppingSpree = this.doneShoppingSpree.bind(this);
    this.updateExitModalStatus = this.updateExitModalStatus.bind(this);
    this.showShareModal = this.showShareModal.bind(this);
    this.startOnboarding = this.startOnboarding.bind(this);
    this.closeOnboarding = this.closeOnboarding.bind(this);
    this.hideZopim = this.hideZopim.bind(this);
    this.showValues = this.showValues.bind(this);
    this.addChatMessage = this.addChatMessage.bind(this);
    this.handleCartValueChanges = this.handleCartValueChanges.bind(this);
    win.startShoppingSpree = this.startOnboarding;
    this.startListeningForToast = this.startListeningForToast.bind(this);
    this.state = this.setInitialState();
  }

  startListeningForToast() {
    super.connectToFirebase();
    const { firebaseNodeId } = this.state;
    const spreeFirebase = firebase.apps[0].database();
    console.log('firebaseNodeId', firebaseNodeId);
    this.chatsDB  = spreeFirebase.ref( firebaseNodeId + "/chats" );
    this.cartDB = spreeFirebase.ref( firebaseNodeId + "/cart" );

    // Listeners
    this.chatsDB.on( 'child_added', this.addChatMessage );
    this.chatsDB.once( 'value', this.showValues );
    this.cartDB.on( 'value', this.handleCartValueChanges);
  }

  handleCartValueChanges(data){
    console.log('cartVal Changes', data.val());
     if( data && data.val) {
       console.log('setting cart values', data);
       this.setState({myItems: data.val()});
     }
  }

  componentDidMount() {
    this.hideZopim();
    this.startListeningForToast();
  }

  showValues(data) {
    const chatValues = data.val();
    if(chatValues) {
      const chatKeys = Object.keys(chatValues);
      const lastChatTime = Math.max(...chatKeys.map(k => chatValues[k].created_at));
      this.setState({
        lastChatTime
      });
    }
  }

  renderToast({type, from, value}){
    switch (type) {
    case 'share_dress':
      return (
        <span>
          <img className="toast-img" src={value.image} />
          <span>{from.name} added a style to chat</span>
        </span>
      );
    case 'discount':
      return (<span>{value}</span>);
    case 'joined':
      return( <span>{from.name} joined</span>);
    case 'text':
    default:
      return (<span>{from.name} said "{value}"</span>);
    }
  }

  addChatMessage(data, prevChildKey) {
    const dataVal = data.val();
    if(data.val()['created_at'] > this.state.lastChatTime) {
      toast(this.renderToast(dataVal), {
        closeButton: <span className="ToastAlert__closeButton">&times;</span>,
        className: `ToastAlert__${dataVal.type}`
      });
    }
  }

  fetchAndClearStartingState() {
    const toReturn = this.cookies.get('shopping_spree_starting_state');
    this.cookies.remove('shopping_spree_starting_state');
    return toReturn;
  }

  setInitialState() {
    const startingState = this.fetchAndClearStartingState();
    const name = this.cookies.get('shopping_spree_name');
    const icon = parseInt(this.cookies.get('shopping_spree_icon'));
    const email = this.cookies.get('shopping_spree_email');
    const firebaseId = this.cookies.get('shopping_spree_id');

    let display = 'none';
    let minimize = false;

    if (startingState) {
      display = startingState;
    } else if (firebaseId) {
      display = 'chat';
      minimize = true;
    }

    return {
      display,
      name,
      email,
      icon,
      firebaseNodeId: firebaseId,
      minimize,
      showAddToCartModal: false,
      startingState: display,
      dressAddingToCart: null,
      showExitModal: false,
      myItems: {}, // Object of keys
    };
  }

  startOnboarding() {
    this.setState(
      {
        display: 'onboarding',
      },
    );
  }
  showAddToCartModal(dress) {
    this.setState({
      showAddingToCartModal: true,
      dressAddingToCart: dress,
    });
  }

  closeAddToCartModal() {
    this.setState(
      {
        showAddingToCartModal: false,
        dressAddingToCart: null,
        display: 'cart',
        minimize: false,
      },
    );
  }

  updateExitModalStatus() {
    const { showExitModal } = this.state;
    this.setState({
      showExitModal: !showExitModal
    })
  }

  deleteAllItemsFromMyCart(){
    const { myItems, name } = this.state;
    const keys = myItems ? Object.keys(myItems) : [];
    let countRemoved = 0;

    keys.forEach(firebaseKey => {
      const item = myItems[firebaseKey];
      console.log('this item', myItems[firebaseKey]);
      if( item.entry_for.email === this.state.email ){
        this.cartDB.child( firebaseKey ).remove();
        countRemoved += 1;
      }
    });

    if (countRemoved >= 1){
      this.createFamebotMessage(
        name + " left your group! "
        + "You are now down to "
        + this.calculateDiscount({totalItems: keys.length - countRemoved})
        + "% off", "discount",
        "discount", // type
      );
    }
  }

  doneShoppingSpree() {
    this.cookies.remove('shopping_spree_name');
    this.cookies.remove('shopping_spree_email');
    this.cookies.remove('shopping_spree_id');
    this.deleteAllItemsFromMyCart();

    this.setState(
      {
        display: 'none',
        showExitModal: false,
      },
    );
  }

  showShareModal() {
    this.setState(
      {
        display: 'share',
      },
    );
  }

  closeOnboarding() {
    this.setState(
      {
        display: 'none',
      },
    );
  }

  doneSharing() {
    this.setState(
      {
        display: 'chat',
        minimize: false,
      },
    )
  }

  changeDisplayStatus(display){
    this.setState({
      display
    })
  }

  doneOnboarding(email, name, icon, shoppingSpreeId)
  {
    this.cookies.set('shopping_spree_name', name, { path: '/', secure: false });
    this.cookies.set('shopping_spree_icon', icon, { path: '/', secure: false });
    this.cookies.set('shopping_spree_email', email, { path: '/', secure: false });
    this.cookies.set('shopping_spree_id', shoppingSpreeId, { path: '/', secure: false });

    this.setState(
      {
        display: 'share',
        name,
        email,
        icon,
        firebaseNodeId: shoppingSpreeId,
      },
    );

    this.startListeningForToast();
  }

  hideZopim() {
    if (win.$zopim && win.$zopim.livechat) {
      win.$zopim.livechat.hideAll();
    } else {
      win.requestAnimationFrame(this.hideZopim);
    }
  }

  render() {
    return (
      <div>
        <div>
          <div className="ToastAlert__container">
            <ToastContainer
              position="top-right"
              type="default"
              autoClose={8000}
              hideProgressBar
              newestOnTop={false}
              closeOnClick
              pauseOnHover
            />
          </div>
        </div>
        {
          this.state.showAddingToCartModal && (
            <AddToCartModal
              dress={this.state.dressAddingToCart}
              firebaseAPI={this.props.firebaseAPI}
              firebaseDatabase={this.props.firebaseDatabase}
              firebaseNodeId={this.state.firebaseNodeId}
              name={this.state.name}
              email={this.state.email}
              icon={this.state.icon}
              closeModal={this.closeAddToCartModal}
              />
          )
        }
        <div className={this.state.display === 'chat' || this.state.display === 'cart' ? '' : 'hidden' }>
        {this.state.firebaseNodeId &&  this.state.email && this.state.name &&
         <Drawer
         firebaseAPI={this.props.firebaseAPI}
         firebaseDatabase={this.props.firebaseDatabase}
         firebaseNodeId={this.state.firebaseNodeId}
         name={this.state.name}
         display={this.state.display}
         email={this.state.email}
         icon={this.state.icon}
         closed={this.state.minimize}
         showAddToCartModal={this.showAddToCartModal}
         doneShoppingSpree={this.doneShoppingSpree}
         showShareModal={this.showShareModal}
         changeDisplayStatus={this.changeDisplayStatus}
         updateExitModalStatus={this.updateExitModalStatus} />
        }
      </div>
        {
        this.state.display === 'share' &&
          <ShareModal
        hasEntered={this.state.startingState === 'chat'}
        firebaseNodeId={this.state.firebaseNodeId}
        nextStep={this.doneSharing}
          />
      }
      {
        this.state.showExitModal &&
          <Modal
        isOpen={true}
        onRequestClose={() => false}
        className="ExitModal font-sans-serif"
          >
          <p
        onClick={this.updateExitModalStatus}
        className="font-sans-serif ExitModal__closeIcon">
          &times;
        </p>
          <p className="headline font-sans-serif">Are you sure you want to exit?</p>
          <div className="ExitModal__buttonContainer">
          <span onClick={this.updateExitModalStatus} className="btn btn-lrg">GO BACK</span>
          <span onClick={this.doneShoppingSpree} className="btn btn-black btn-lrg">EXIT</span>
          </div>
          </Modal>
      }
      {
        this.state.display === 'onboarding' &&
          <Onboarding firebaseDatabase={this.props.firebaseDatabase} doneOnboarding={this.doneOnboarding} close={this.closeOnboarding} shoppingSpreeId={this.state.firebaseNodeId} />
      }
      </div>
    );
  }


}


ShoppingSpree.propTypes = {
  firebaseAPI: PropTypes.string.isRequired,
  firebaseDatabase: PropTypes.string.isRequired,
};

ShoppingSpree.defaultProps = {
  name: null,
  icon: 0,
  email: null,
  firebaseId: null,
};
