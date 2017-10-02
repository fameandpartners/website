import React, { PropTypes } from 'react';

class MarketingPage extends React.Component {
  constructor(props, context) {
    super(props, context);
  }

  render(){
    return (
      <div>
        {this.props.children}
      </div>
    );
  }
}

MarketingPage.propTypes = {
  children: PropTypes.object
};

export default MarketingPage;
