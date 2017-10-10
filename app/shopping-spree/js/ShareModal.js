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
                    Copy and share this link to start shopping with your friends!
                  </div>
                </div>
                <div className="row equal">
                  <div className="col-xs-7 col-md-4 col-md-push-3 no-right-gutter">
                    <input readOnly defaultValue={this.state.url} className="form-control input-lg" type="text"></input>
                  </div>
                  <div className="col-xs-5 col-md-2 col-md-push-3 no-left-gutter">
                    <a data-delay-hide='800'
                       data-event="click"
                       data-tip="copied!"
                       ref={i => this.copyTrigger = i}
                      className='btn btn-black btn-block no-horizontal-padding'
                      >Copy Link</a>
                    <ReactTooltip  afterShow={ () => ReactTooltip.hide(findDOMNode(this.copyTrigger)) } place="bottom" effect="solid"/>
                  </div>
                </div>
                <div id="start-button" className="row">
                  <div  className="col-xs-12 col-lg-3 col-lg-push-4 no-gutter-mobile">
                    <a onClick={this.props.nextStep} className="center-button-text btn btn-md btn-black btn-block">Start Shopping Spree</a>
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

