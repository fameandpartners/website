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

function getTileImages(){
  // Antipattern. This should be injected into props on startup
  return (typeof window === 'object' && window.SLAY_IT_FORWARD && window.SLAY_IT_FORWARD.tileImages) ?
    window.SLAY_IT_FORWARD.tileImages : [];
}

function renderBackgroundImg(path){
  const style = { backgroundImage: `url(${path})` };
  return (
    <div className="empowered-woman-img" style={style}></div>
  );
}

const SlayItForward = (props) => {
  const { dispatch, SlayItForwardState } = props;
  const tileImages = getTileImages();

  return (
    <div className="slay-it-forward">
      <MarketingPage>
        <MarketingSection className="MarketingSection-slay slay-banner-hero">
          <div className="clearfix">
            <div className="strong-woman"></div>
            <div className="strong-woman"></div>
            <div className="strong-woman"></div>
            <div className="strong-woman"></div>
            <div className="hashtag-banner u-float--left inner-buffer u-textAlign--center">#SLAYITFORWARD</div>
            <div className="strong-woman"></div>
            <div className="strong-woman"></div>
            <div className="strong-woman"></div>
            <div className="strong-woman"></div>
          </div>
        </MarketingSection>

        <MarketingSection className="MarketingSection-slay slay-reasoning inner-buffer">
          <div>
            <p className="u-textAlign--center">
              The comments that have been made about women by America’s President-elect
              are not OK. The treatment of women by America’s President-Elect is not OK. <br />
              We cannot and will not stand by while women are derogated and assaulted and disregarded
            </p>
            <p className="u-textAlign--center">
              We feel it is our obligation and duty to remind women how amazing and powerful and independent we are.
            </p>
            <p className="u-textAlign--center">
              So, women everywhere, listen up:
            </p>
            <p className="u-textAlign--center font-medium">
              We are <em>capable</em>. We are <em>worthy</em>. We are more than our <em>bodies</em>,
              our <em>looks</em>, our <em>sex</em>. <br />We slay.
            </p>
            <p className="u-textAlign--center">
              Let’s #SLAYITFORWARD.
            </p>
            <p className="u-textAlign--center">
              Use the hashtag on Instagram to shout out a woman in your life who
              inspires you–or who needs some inspiration right now–and tell her how
              she slays. Now it’s her turn to #SLAYITFORWARD.<br />For every hashtag used,
              Fame and Partners will donate $1 to the charities below–ones that support
              our most vulnerable, marginalized communities.
            </p>
            <p className="u-textAlign--center">
              Join us in creating an unstoppable chain of women empowering women..
              Join us in donating to the people who need it most right now. Join us and
              <br />#SLAYITFORWARD.
            </p>
          </div>
        </MarketingSection>

        <MarketingSection className="MarketingSection-slay slay-dynamic-trends">
          <div>
            <p>
              Watch us #SLAYITFORWARDin real time.<br />
              –--<br />
              The movement is756 people strong.
            </p>
          </div>
        </MarketingSection>

        <MarketingSection className="MarketingSection-slay slay-carousel">
          <div className="slay-carousel-container clearfix">
            {tileImages.map((path)=>{
              return renderBackgroundImg(path);
            })}
          </div>
        </MarketingSection>

        <MarketingSection className="MarketingSection-slay slay-aside">
          <p className="font-medium u-textAlign--center inner-buffer">
            <em>Together</em>, we’ve pledged <b className="font--secondary">$10,000</b> to remind women how amazing they are.
          </p>
        </MarketingSection>

        <MarketingSection className="MarketingSection-slay slay-organizations inner-buffer">
          <div className="slay-organizations-container">
            Organizations go here
          </div>
        </MarketingSection>

        <MarketingSection className="MarketingSection-slay slay-carousel clearfix">
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
