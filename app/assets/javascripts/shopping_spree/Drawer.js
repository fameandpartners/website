import React from 'react';
import ChatList from './ChatList'

class Drawer extends React.Component
{
    constructor(props)
    {
        super(props);

        this.state =
            {
                closed: true
                
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
              <div className={"shopping-spree-container container " + (this.state.closed ? 'collapsed' : '')}>
              <div className="full-toggle-btn" onClick={this.handleToggle}></div>                  
              <div className="row header vertical-align">
              <div className="col-xs-2">
              <i className={"toggle-btn " + (this.state.closed ? "closed-caret" : "open-caret")}  onClick={this.handleToggle}></i>
              </div>
              <div className="col-xs-8 text-center">Shopping Spree</div>
              <div className="col-xs-2"><span className="icon icon-bag"></span></div>
              </div>
              <div className="row"><ChatList /></div>
              </div>
          );
    }
}

export default Drawer;
