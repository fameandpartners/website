import React, { PropTypes } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import Immutable from 'immutable';
import * as slayActions from '../actions/SlayItForwardActions';

// Components
import MarketingPage from '../components/Marketing/MarketingPage.jsx';
import MarketingSection from '../components/Marketing/MarketingSection.jsx';

function select(state) {
  return state;
}

const SlayItForward = (props) => {
  const { dispatch, SlayItForwardState } = props;
  return (
    <div className="slay-it-forward">
      <MarketingPage>
        <MarketingSection className="MarketingSection-slay slay-banner-hero">
          <div>
            <div className="strong-woman"></div>
            <div className="strong-woman"></div>
            <div className="strong-woman"></div>
            <div className="strong-woman"></div>
            <div className="hashtag-banner inner-buffer">#SLAYITFORWARD</div>
            <div className="strong-woman"></div>
            <div className="strong-woman"></div>
            <div className="strong-woman"></div>
            <div className="strong-woman"></div>
          </div>
        </MarketingSection>

        <MarketingSection className="MarketingSection-slay slay-reasoning inner-buffer">
          <div>
            This is a section
          </div>
        </MarketingSection>

        <MarketingSection className="MarketingSection-slay slay-dynamic-trends">
          <div>
            This is a section
          </div>
        </MarketingSection>

        <MarketingSection className="MarketingSection-slay slay-aside">
          <div>
            Together, we’ve pledged $10,000 to remind women how amazing they are.
          </div>
        </MarketingSection>

        <MarketingSection className="MarketingSection-slay slay-organizations">
          <div>
            Organizations go here
          </div>
        </MarketingSection>

        <MarketingSection className="MarketingSection-slay slay-carousel">
          <div>
            Carousel stuff goes here
          </div>
        </MarketingSection>

        <MarketingSection className="MarketingSection-slay slay-ceo-letter">
          <div>
            From our CEO
          </div>
        </MarketingSection>

      </MarketingPage>
    </div>
  );
};

SlayItForward.propTypes = {
  dispatch: PropTypes.func.isRequired,
  SlayItForwardState: PropTypes.object
};

export default connect(select)(SlayItForward);
