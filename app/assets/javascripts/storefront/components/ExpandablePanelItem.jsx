import React, { Component, PropTypes } from 'react';

class ExpandablePanel extends Component {
  constructor(props) {
    super(props);
  }

  render(){
    return (
      <div className="ExpandablePanelItem">

      </div>
    );
  }
}

ExpandablePanel.propTypes = {
  children: PropTypes.object
};

export default ExpandablePanel;
