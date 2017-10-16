/* eslint-disable */
import React from 'react';
import Clipboard from 'clipboard';
import ReactTooltip from 'react-tooltip';
import {findDOMNode} from 'react-dom';

export default class ShareModal extends React.Component
{
    constructor( props )
    {
        super( props );
        this.state =
            {
                url: location.protocol+'//'+location.hostname+(location.port ? ':'+location.port: '') + "/shopping_sprees/" + this.props.firebaseNodeId + "/join"

            };
    }

    componentDidMount()
    {
        this.setState(
            {
                clipboard: new Clipboard(this.copyTrigger,
                                         {
                                             text: () => this.state.url
                                         }
                                        )
            }
        );
    }

    render()
    {
        return(
            <div>
              <div className='shopping-spree-share-modal-background shopping-spree'>
              </div>

              <div className='shopping-spree shopping-spree-share-modal container'>
                <div className="row">
                  <div className="modal-headline text-center col-xs-10 col-xs-push-1 col-md-10 col-md-push-1 no-gutter-mobile">
                    Let’s Clique to Buy. Copy and share this link with your friends.
                  </div>
                </div>
                <div className="row equal">
                  <div className="col-xs-12 col-lg-12">
                    <input readOnly defaultValue={this.state.url} className="input-lg col-xs-8" type="text"></input>
                    <div className="col-xs-4 no-horizontal-padding">
                      <a data-delay-hide='800'
                      data-event="click"
                      data-tip="copied!"
                      ref={i => this.copyTrigger = i}
                      className='btn btn-black btn-block col-xs-3'
                      >Copy Link</a>
                      <ReactTooltip  afterShow={ () => ReactTooltip.hide(findDOMNode(this.copyTrigger)) } place="bottom" effect="solid"/>
                    </div>
                  </div>
                </div>
                <div className="start-button-wrapper">
                  <div id="start-button">
                    <div  className="col-xs-12 col-lg-6 margin--center float-none no-gutter-mobile">
                      { this.props.hasEntered
                        ? <a onClick={this.props.nextStep} className="center-button-text btn btn-md btn-black btn-block">Continue Clique</a>
                        : <a onClick={this.props.nextStep} className="center-button-text btn btn-md btn-black btn-block">Start Clique to buy</a>
                      }
                    </div>
                  </div>
                </div>
              </div>
            </div>

        );
    }
}


ShareModal.propTypes = {
    firebaseNodeId: React.PropTypes.string.isRequired
};
