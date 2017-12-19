/* eslint-disable */

import React from "react";
import PropTypes from "prop-types";
import * as firebase from "firebase";
import FirebaseComponent from "./FirebaseComponent";

// Polyfills
import win from "./windowPolyfill";

export default class ChatBar extends FirebaseComponent {
  constructor(props) {
    super(props);
    this.sendMessage = this.sendMessage.bind(this);
    this.addProductToFirebase = this.addProductToFirebase.bind(this);
    win.addToShoppingSpree = this.addProductToFirebase;
    this.detectEnterKey = this.detectEnterKey.bind(this);
    this.sendStepMessage = this.sendStepMessage.bind(this);
    // this.setMasterUserEmail = this.setMasterUserEmail.bind(this);
    this.addItem = this.addItem.bind(this);
    this.updateLocalStateStep = this.updateLocalStateStep.bind(this);
    // this.addMember = this.addMember.bind(this);

    this.state = {
      // members: [],
      // masterUserEmail: null,
      step: 0,
      cliqueCart: [],
    };
  }

  addProductToFirebase(
    productID,
    productVariantId,
    productName,
    productDescription,
    productPrice,
    productImage,
    productUrl,
    color,
    customizations,
  ) {
    this.createShareDressMessage(
      this.props.name,
      this.props.email,
      this.props.icon,
      productID,
      productVariantId,
      productName,
      productDescription,
      productPrice,
      productImage,
      productUrl,
      color,
      customizations,
    );
    this.addItem(productName);
    this.props.transitionToChat();
  }

  // printMemberError(error) {
  //   console.log('Member List error!');
  //   console.log(error);
  // }

  sendStepMessage() {
    const {
      cliqueCart,
      step,
    } = this.state;

    if ((step == 2) && (cliqueCart.length > 0)) {
      this.createStepMessage(3);
      this.updateStepInDB(3);
    }
  }

  addItem(product) {
    console.log(`Adding ${product} to Clique Cart...`);

    let updatedCart = [...this.state.cliqueCart, product];

    this.setState({
      cliqueCart: updatedCart,
    }, function() {
      this.sendStepMessage();
    });
  }

  // addItem(data) {
  //   const item = data.val().value;
  //   console.log(`Adding ${item.name} to Clique Cart...`);

  //   let updatedCart = [...this.state.cliqueCart, item];

  //   this.setState({
  //     cliqueCart: updatedCart,
  //   }, function() {
  //     this.sendStepMessage();
  //   });
  // }

  // addMember(data) {
  //   const member = data.val();
  //   console.log(`${member.from.name} joined Shopping Spree...`);

  //   this.setState(prevState => ({
  //     members: [...prevState.members, member.from],
  //   }));

  //   this.setMasterUserEmail();
  // }

  updateLocalStateStep(data) {
    let step = data.val();
    console.log(`updateLocalStateStep(${step})...`);

    this.setState({ step });
  }

  // setMasterUserEmail() {
  //   this.databaseRef("members")
  //     .orderByKey()
  //     .limitToLast(1)
  //     .once("value")
  //     .then((snapshot) => {
  //       let key = Object.keys(snapshot.val())[0];
  //       this.setState({
  //         masterUserEmail: snapshot.val()[key].from.email,
  //       });
  //       this.sendStepMessage();
  //     });
  // }

  // sendStepMessage() {
  //   const {
  //     email,
  //   } = this.props;
  //   const {
  //     cliqueCart,
  //     masterUserEmail,
  //     members,
  //     step,
  //   } = this.state;

  //   console.group('sendStepMessage()...');
  //   console.log(`Props Email: ${email}`);
  //   console.log(`Master Email: ${masterUserEmail}`);
  //   console.log(`Step: ${step}`);
  //   console.log('--- Members ---');
  //   console.log(members);
  //   console.log('--- Clique Cart ---');
  //   console.log(cliqueCart);
  //   console.groupEnd();

  //   if ((step == 2) && (cliqueCart.length > 0)) {
  //     this.createStepMessage(3);
  //     this.updateStepInDB(3);
  //   }

  //   const masterUser = (email == masterUserEmail);

  //   if (masterUser) {
  //     if ((step == 0) && (members.length == 1)) {
  //       this.createStepMessage(1);
  //       this.updateStepInDB(1);
  //     } else if ((step == 1) && (members.length == 2)) {
  //       this.createStepMessage(2);
  //       this.updateStepInDB(2);
  //     }
  //   } else {
  //     return;
  //   }
  // }

  componentDidMount() {
    this.initializeFirebase();
  }

  initializeFirebase() {
    super.connectToFirebase();

    this.databaseRef("step")
      .on("value", this.updateLocalStateStep);

    this.chatsDB = firebase.apps[0]
      .database()
      .ref(this.props.firebaseNodeId + "/chats");

    // this.databaseRef("members")
    //   .on("child_added", this.addMember, this.printMemberError);
  }

  sendMessage() {
    if (this.textInput.value.trim() !== "") {
      this.createTextMessage(
        this.textInput.value,
        this.props.name,
        this.props.email,
        this.props.icon,
      );
    }
    this.textInput.value = "";
  }

  detectEnterKey(e) {
    if (e.key === "Enter") {
      this.sendMessage();
    }
  }

  render() {
    return (
      <div className="chat-bar-container">
        <div className="chat-bar equal">
          <div className="col-xs-9 no-right-gutter no-left-gutter">
            <input
              placeholder="Share and shop!"
              onKeyPress={this.detectEnterKey}
              ref={input => {
                this.textInput = input;
              }}
              className="shoppingSpreeTextInput"
              type="text"
            />
          </div>
          <div className="col-xs-3 no-left-gutter no-right-gutter">
            <a
              onClick={this.sendMessage}
              className="btn btn-shopping-spree-blue"
            >
              Send
            </a>
          </div>
        </div>
      </div>
    );
  }
}

ChatBar.propTypes = {
  firebaseAPI: PropTypes.string.isRequired,
  firebaseDatabase: PropTypes.string.isRequired,
  firebaseNodeId: PropTypes.string.isRequired,
  name: PropTypes.string.isRequired,
  email: PropTypes.string.isRequired,
  icon: PropTypes.number.isRequired,
  transitionToChat: PropTypes.func.isRequired,
};
