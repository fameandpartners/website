import React from 'react';

class SidePanel extends React.Component {
  constructor(props, context) {
    super(props, context);

    this.state = {
      active: false
    };

    this.openMenu = this.openMenu.bind(this);
    this.closeMenu = this.closeMenu.bind(this);
  }

  openMenu() {
    this.setState({active: true});
  }

  closeMenu() {
    this.setState({active: false});
  }

}

export default SidePanel;
