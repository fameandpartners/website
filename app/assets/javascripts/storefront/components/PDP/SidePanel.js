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
    // removes body scroll bar when opened
    if($(window).width() < 992) {
      $('body').addClass('no-scroll');
    }
  }

  closeMenu() {
    this.setState({active: false});
    // and adds it back in when closed
    if($(window).width() < 992) {
      $('body').removeClass('no-scroll');
    }
  }

}

export default SidePanel;
