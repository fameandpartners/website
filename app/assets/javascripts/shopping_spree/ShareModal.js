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

              <div className='shopping-spree-share-modal'>
                <div className="row">
                  <div  className="col-xs-12 col-lg-2 col-lg-push-5 no-gutter-mobile">
                    <a className="btn btn-lrg btn-black btn-block">Start Shopping Spree</a>
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

