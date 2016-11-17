import React from 'react';

class MarketingPage extends React.Component {
  constructor(props, context) {
    super(props, context);
  }

  render(){
    <div>
      Marketing Page
      {this.props.children}
    </div>
  }

}

export default MarketingPage;
