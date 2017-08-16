import React from 'react';

const Drawer = () =>
      {
          return (
                  <div>
                  <div className="row header vertical-align">
                  <div className="col-xs-2">
                  <i className="line-caret toggle-btn"
              data-toggle="collapse" data-target=".chat-content"></i>
                  </div>
                  <div className="col-xs-8 text-center">Shopping Spree</div>
                  <div className="col-xs-2"><span className="icon icon-bag"></span></div>
                  </div>
                  <div className="row">
                  <div className="chat-list">
                  <div className="chat-content collapse out">Test</div>
                  </div>
                  </div>
                  </div>
          );

      }

export default Drawer;
