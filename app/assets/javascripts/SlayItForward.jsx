import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import Immutable from 'immutable';
import * as slayActions from '../actions/SlayItForwardActions';

// Components
import MarketingPage from '../components/Marketing/MarketingPage.jsx';
import MarketingSection from '../components/Marketing/MarketingSection.jsx';

//Libraries
import Resize from '../decorators/Resize.jsx';
import breakpoints from '../libs/breakpoints';

function select(state) {
  return state;
}

function getImages(key){
  // Antipattern. This should be injected into props on startup
  return (typeof window === 'object' && window.SLAY_IT_FORWARD && window.SLAY_IT_FORWARD[key]) ?
    window.SLAY_IT_FORWARD[key] : [];
}

function splitArray(arr){
  if (arr.length){
    const half = Math.ceil(arr.length / 2);
    const leftSide = arr.slice(0, half);
    const rightSide = arr.slice(half, arr.length);
    return [leftSide, rightSide];
  }
  return [[],[]];
}

class SlayItForward extends Component {
  constructor(props) {
    super(props);
    this.renderBackgroundImg = this.renderBackgroundImg.bind(this);
  }

  renderBackgroundImg(path){
    const {breakpoint} = this.props;
    const style = { backgroundImage: `url(${path})` };
    return (
      <div className="empowered-woman-img" style={style}></div>
    );
  }

  render(){
    const { dispatch, SlayItForwardState } = this.props;
    const tileImages = getImages('tileImages');
    const bannerImages = (this.props.breakpoint === 'mobile') ?
      splitArray(getImages('heroImagesMobile')) :
      splitArray(getImages('heroImagesBig'));

    return (
      <div className="slay-it-forward">
        <MarketingPage>
          <MarketingSection className="MarketingSection-slay slay-banner-hero u-position--relative">
            <div className="clearfix">
              {bannerImages[0].map((imgPath)=>{
                return this.renderBackgroundImg(imgPath);
              })}
              <h3 className="main-slay-text hashtag-banner u-float--left inner-buffer u-textAlign--center">#SLAYITFORWARD</h3>
              {bannerImages[1].map((imgPath)=>{
                return this.renderBackgroundImg(imgPath);
              })}
            </div>
          </MarketingSection>

          <MarketingSection className="MarketingSection-slay slay-reasoning inner-buffer">
            <div>
              {this.props.breakpoint === 'mobile' ? null :
                <h3 className="main-slay-text u-textAlign--center font--secondary">#SLAYITFORWARD</h3>
              }
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
              We are <em>capable</em>. We are <em>worthy</em>.<br /> We are more than our <em>bodies</em>,
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
          {tileImages.map((imgPath)=>{
            return this.renderBackgroundImg(imgPath);
          })}
        </div>
      </MarketingSection>

      <MarketingSection className="MarketingSection-slay slay-aside">
        <p className="font-medium u-textAlign--center inner-buffer">
          <em>Together</em>, we’ve pledged <b className="font--secondary">$10,000</b> to remind women how amazing they are.
          </p>
        </MarketingSection>

        <MarketingSection className="MarketingSection-slay slay-organizations inner-buffer">
          <div className="slay-organizations-container u-textAlign--center inner-buffer">
            <p className="font-medium">The organizations <em>you're</em> supporting</p>

            <p className="font--secondary u-textTransform--uppercase title">American Civil Liberties Union (ACLU).</p>
            <p>They defend the individual rights and liberties guaranteed by the Constitution.</p>

            <p className="font--secondary u-textTransform--uppercase title">Future Project.</p>
            <p>They help young people fulfill their potential and teach them skills they need for the future.</p>

            <p className="font--secondary u-textTransform--uppercase title">Naral Pro-choice America</p>
            <p>They advocate for women’s reproductive rights and freedom.</p>

            <p className="font--secondary u-textTransform--uppercase title">National Immigration Law Center.</p>
            <p>They fight for the rights of low-income immigrants with litigation, policy analysis, and advocacy.</p>

            <p className="font--secondary u-textTransform--uppercase title">National Organization for Women (NOW).</p>
            <p>They advocate for equal rights for women.</p>

            <p className="font--secondary u-textTransform--uppercase title">Showing Up For Racial Justice.</p>
            <p>They are a national network of groups and individuals organizing white people for racial justice.</p>

            <p className="font--secondary u-textTransform--uppercase title">Planned Parenthood</p>
            <p>They are the nation’s leading sexual and reproductive healthcare provider.</p>

            <p className="font--secondary u-textTransform--uppercase title">Rape, Abuse & Incest Network (RAINN).</p>
            <p>They are the largest anti-sexual violence organization in the country.</p>

            <p className="font--secondary u-textTransform--uppercase title">Running Start.</p>
            <p>They educate young women about the importance of politics through the Young Women’s Political Leadership Program.</p>

            <p className="font--secondary u-textTransform--uppercase title">She Should Run.</p>
            <p>They aim to get more women into elected positions of power.</p>

            <p className="font--secondary u-textTransform--uppercase title">Sylvia Rivera Law Project.</p>
            <p>They provide legal service to low-income people and people of color who are transgender, intersexor otherwise gender non-conforming.</p>

            <p className="font--secondary u-textTransform--uppercase title">Young Center for Immigrant Children’s Rights.</p>
            <p>They fight for the best interests of children who come to the U.S. on their own.</p>
          </div>
        </MarketingSection>

        <MarketingSection className="MarketingSection-slay slay-carousel clearfix">
          <div>
            <p className="u-textAlign--center font-medium">Post, empower<br />and <em>give back</em>.</p>
            <div className="insta-carousel"></div>
          </div>
        </MarketingSection>

        <MarketingSection className="MarketingSection-slay slay-ceo-letter">
          <div className="u-textAlign--center">
            <p className="font-medium">From our CEO.</p>
            <div>This is an image of Nyree</div>
            <p>A message from Nyree Corby, a female founder and CEO, to women everywhere.</p>
            <p className="font--secondary">READ NOW <span>></span></p>
          </div>
        </MarketingSection>

      </MarketingPage>
    </div>
  );

  }
}

SlayItForward.propTypes = {
  breakpoint: PropTypes.string,
  dispatch: PropTypes.func.isRequired,
  SlayItForwardState: PropTypes.object
};

export default Resize(breakpoints)(connect(select)(SlayItForward));
