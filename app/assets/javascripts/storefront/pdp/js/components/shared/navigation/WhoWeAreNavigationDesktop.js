import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';

// CSS
import '../../../../css/components/WhoWeAreNavigation.scss';

// Constants
import { NAVIGATION_LINKS } from '../../../constants/AppConstants';

// Components
import NavLinkCol from './NavLinkCol';

class WhoWeAreNavigation extends PureComponent {
  splitLinks(remainder) {
    return NAVIGATION_LINKS.WHO_WE_ARE.filter((l, i) => i % 2 === remainder);
  }

  render() {
    return (
      <div
        ref={this.props.childRef}
        className="WhoWeAreNavigation u-width--full layout-container"
      >
        <div className="WhoWeAreNavigation__link-container u-center grid">
          <NavLinkCol
            links={this.splitLinks(1)}
          />
          <NavLinkCol
            links={this.splitLinks(0)}
          />
        </div>
      </div>
    );
  }
}

WhoWeAreNavigation.propTypes = {
  childRef: PropTypes.func.isRequired,
};

export default WhoWeAreNavigation;
