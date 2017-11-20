/* eslint-disable */

import React from "react";
import * as firebase from "firebase";

export default class FirebaseComponent extends React.Component {
  constructor(props) {
    super(props);
    this.setFirebaseNodeId(this.props.firebaseNodeId);
  }

  componentWillMount() {
    console.log(firebase);
  }

  setFirebaseNodeId(nodeId) {
    this.firebaseNodeId = nodeId;
  }

  calculateDiscount({ totalItems = 0 }) {
    const SOLE_DISCOUNT = 5;
    if (totalItems === 1) {
      return SOLE_DISCOUNT;
    }

    if (totalItems > 1) {
      const discount = SOLE_DISCOUNT + (totalItems - 1) * 2.5;
      return discount >= 25 ? 25 : discount;
    }

    return 0;
  }

  connectToFirebase() {
    if (firebase.apps.length === 0) {
      var config = {
        apiKey: this.props.firebaseAPI,
        authDomain: this.props.firebaseDatabase + ".firebaseapp.com",
        databaseURL: "https://" + this.props.firebaseDatabase + ".firebaseio.com",
        projectId: this.props.firebaseDatabase,
        storageBucket: this.props.firebaseDatabase + ".appspot.com",
        messagingSenderId: "868619391913",
      };
      // firebase.database.enableLogging(true);
      firebase.initializeApp(config);
    }
  }

  updateStepInDB(step) {
    console.log(`updateStepInDB(${step})`);

    let updates = {
      step: step
    };
    this.databaseRef("").update(updates);
  }

  createNewShoppingSpree() {
    console.log('createNewShoppingSpree()...');

    let ref = this.databaseRef("").push();
    ref.set({
      step: null,
      members: [],
      chats: [],
      created_at: firebase.database.ServerValue.TIMESTAMP,
    });
    this.firebaseNodeId = ref.key;

    // initialize steps
    this.updateStepInDB(0);

    return ref.key;
  }

  createJoinedMessage(name, email, icon) {
    console.log(`createJoinedMessage: ${name}`);

    let newMessage = this.databaseRef("chats").push();
    newMessage.set({
      type: "joined",
      created_at: firebase.database.ServerValue.TIMESTAMP,
      from: {
        email: email,
        icon: icon,
        name: name,
      },
    });

    let newUser = this.databaseRef("members").push();
    newUser.set({
      type: "entered",
      created_at: firebase.database.ServerValue.TIMESTAMP,
      from: {
        email: email,
        name: name,
      },
    });
  }
  createFamebotMessage(text, type) {
    this.createTextMessage(
      text,
      "Fame Bot",
      "help@fameandpartners.com",
      20,
      type,
    );
  }

  createStepMessage(step) {
    switch (step) {
      case 1:
        this.createTextMessage(
          "1",
          "STEP_BOT",
          "help@fameandpartners.com",
          21,
          'step'
        );
        break;

      case 2:
        this.createTextMessage(
          "2",
          "STEP_BOT",
          "help@fameandpartners.com",
          21,
          'step'
        );
        break;

      case 3:
        this.createTextMessage(
          "3",
          "STEP_BOT",
          "help@fameandpartners.com",
          21,
          'step'
        );
        break;
    }
  }

  createFamebotShareDressMessage(
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
      "Fame Bot",
      "help@fameandpartners.com",
      20,
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
  }

  createShareDressMessage(
    name,
    email,
    icon,
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
    let newMessage = this.databaseRef("chats").push();
    newMessage.set({
      type: "share_dress",
      value: {
        name: productName,
        price: productPrice,
        product_id: productID,
        product_variant_id: productVariantId,
        url: productUrl,
        color: color,
        image: productImage,
        customizations,
        description: productDescription,
      },
      created_at: firebase.database.ServerValue.TIMESTAMP,
      from: {
        name: name,
        email: email,
        icon: icon,
      },
    });
  }

  printError(error, data) {
    console.log("Firebase error ");
    console.log(error);
  }

  createTextMessage(text, name, email, icon, type = "text") {
    let newMessage = this.databaseRef("chats").push();
    newMessage.set(
      {
        type,
        value: text,
        created_at: firebase.database.ServerValue.TIMESTAMP,
        from: {
          name: name,
          email: email,
          icon: icon,
        },
      },
      this.printError,
    );
  }

  databaseRef(name) {
    return firebase.apps[0].database().ref(this.firebaseNodeId + "/" + name);
  }
}
