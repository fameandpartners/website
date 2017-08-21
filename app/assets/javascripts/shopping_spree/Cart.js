import React from 'react';
import * as firebase from 'firebase';

import FirebaseComponent from './FirebaseComponent';

export default class ChatList extends FirebaseComponent
{

    render()
    {
        return(
            <div className="row header vertical-align">
            <div className="back-to-spree col-xs-6" onClick={this.props.transitionToChat}>
            <div className="left-caret"></div>
            <div className="back-to-spree-text shopping-spree-headline">
            Back to spree
            </div>
            </div>
            <div className="col-xs-9 col-xs-pull-1">
            Your Bag
            </div>
            <div className="col-xs-3 col-xs-pull-1 text-right">
            23% off
            </div>
            </div>

        )
    }
}
