import React from 'react';
import * as firebase from 'firebase';

export default class FirebaseComponent extends React.Component {
  calculateDiscount(total) {
    let initialDiscount = (total - 200) / 100;
    initialDiscount = Math.round(initialDiscount);
    if (initialDiscount < 0) {
      return 0;
    } else if (initialDiscount > 30) {
      return 30;
    }
    return initialDiscount;
  }

  connectToFirebase() {
    if (firebase.apps.length === 0) {
      const config =
        {
          apiKey: 'AIzaSyDhbuF98kzK0KouFeasDELcOKJ4q7DzhHY',
          authDomain: 'shopping-spree-85d74.firebaseapp.com',
          databaseURL: 'https://shopping-spree-85d74.firebaseio.com',
          projectId: 'shopping-spree-85d74',
          storageBucket: 'shopping-spree-85d74.appspot.com',
        };
      firebase.initializeApp(config);
    }
  }

  createFamebotMessage(text) {
    console.log(text, 'FOR FAMEBOT');
    this.createTextMessage(text, 'Fame Bot', 'help@fameandpartners.com', 20);
  }

  createTextMessage(text, name = 'Mike', email = 'test@gmail.com', icon = 'http://placehold.it/50') {
    const newMessage = this.databaseRef('chats').push();
    console.log(text, name, email, icon);
    console.log(this.databaseRef());
    newMessage.set({ type: 'text',
      value: text,
      created_at: firebase.database.ServerValue.TIMESTAMP,
      from:
      {
        name,
        email,
        icon,
      },
    });
  }
  databaseRef(name) {
    return firebase.apps[0].database().ref(`test/${name}`);
  }
}
