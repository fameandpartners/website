import React from 'react';

class Drawer extends React.Component
{
    constructor()
    {
        super();
        this.state =
            {
                closed: false
            };
        this.handleToggle = this.handleToggle.bind(this);        
    }

    handleToggle()
    {
        this.setState( { closed: !this.state.closed } );
    }
    
    render()
    {
          return (
                  <div className="shopping-spree-container container">
                  <div className="row header vertical-align">
                  <div className="col-xs-2">
                  <i className={"toggle-btn " + (this.state.closed ? "closed-caret" : "open-caret")}
              data-toggle="collapse" data-target=".chat-content" onClick={this.handleToggle}></i>
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
}

export default Drawer;
