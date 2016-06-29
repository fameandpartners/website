import React from 'react';
import SidePanel from './SidePanel';

class SidePanelLength extends SidePanel {
  constructor(props, context) {
    super(props, context);
  }

  render() {
    return (
      <a href="javascript:;" className="c-card-customize__content is-selected">
        <div className="c-card-customize__content__left">Skirt Length</div>
        <div className="c-card-customize__content__right"></div>
      </a>
    );
  }
}

export default SidePanelLength;
