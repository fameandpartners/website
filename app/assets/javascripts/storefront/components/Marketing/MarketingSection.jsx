import React, { PropTypes } from 'react';

class MarketingSection extends React.Component {
  constructor(props) {
    super(props);
  }

  render(){
    return (
      <div className={`MarketingSection ${this.props.className || ''}`}>
        {this.props.children}
      </div>
    );
  }
}

MarketingSection.propTypes = {
  children: PropTypes.object,
  className: PropTypes.object
};

export default MarketingSection;
