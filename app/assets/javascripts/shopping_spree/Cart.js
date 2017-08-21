import React from 'react';
import * as firebase from 'firebase';

import FirebaseComponent from './FirebaseComponent';

export default class ChatList extends FirebaseComponent
{

    render()
    {
        return(
            <div className="row header vertical-align">
            <div className="back-to-spree col-md-4 col-xs-8" onClick={this.props.transitionToChat}>
            <div className="left-caret"></div>
            <div className="back-to-spree-text shopping-spree-headline">
            Back to spree
            </div>
            </div>
            <div className="col-xs-6 col-md-4">
            Your Bag
            </div>
            <div className="col-xs-4 col-md-4 text-center">
            23% off
            </div>
            </div>

        )
    }
}
