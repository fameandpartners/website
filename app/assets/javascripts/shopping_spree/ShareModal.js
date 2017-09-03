import React from 'react';

export default class ShareModal extends React.Component
{
    constructor( props )
    {
        super( props );
    }

    render()
    {
        return(
            <div>
              <div className='shopping-spree-share-modal-background shopping-spree'>
              </div>

              <div className='shopping-spree shopping-spree-share-modal container'>
                <div className="row">
                  <div className="modal-headline text-center col-xs-10 col-xs-push-1 col-lg-2 col-lg-push-5 no-gutter-mobile">
                    Copy and share this link to start shopping with your friends!
                  </div>
                </div>
                <div className="row equal">
                  <div className="col-xs-7 no-right-gutter">
                    <input className="form-control input-lg" type="text"></input>
                  </div>
                  <div className="col-xs-5 no-left-gutter">
                    <a className='btn btn-black btn-block no-horizontal-padding'>Copy Link</a>
                  </div>
                </div>
                <div id="start-button" className="row">
                  <div  className="col-xs-12 col-lg-2 col-lg-push-5 no-gutter-mobile">
                    <a className="btn btn-md btn-black btn-block">Start Shopping Spree</a>
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

