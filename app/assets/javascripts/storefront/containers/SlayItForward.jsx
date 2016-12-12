/* global Modernizr */
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
    this.state = {
      mounted: false
    };
    this.renderBackgroundImg = this.renderBackgroundImg.bind(this);
  }

  componentDidMount(){
    setTimeout(()=>{
      this.setState({mounted: true});
    }, 200);
  }

  renderBackgroundImg(path, className='empowered-woman-img'){
    const {breakpoint} = this.props;
    const style = { backgroundImage: `url(${path})` };
    return (
      <div className={className} style={style}></div>
    );
  }

  renderShareImgs(path){
    const {breakpoint} = this.props;
    if (typeof Modernizr === 'object' && Modernizr.adownload){
      return (
        <a className='link' href={path} download='slayitforward.jpg'>
          <img className="share-tiles" src={path} />
        </a>
      );
    } else {
        return (
          <a className='link' href={path} target='_blank'>
            <img className="share-tiles" src={path} />
          </a>
        );
    }
  }

  render(){
    const { dispatch, SlayItForwardState } = this.props;
    const { mounted } = this.state;
    const tileImages = getImages('tileImages');
    const bannerImages = (this.props.breakpoint === 'mobile') ?
      splitArray(getImages('heroImagesMobile')) :
      splitArray(getImages('heroImagesBig'));
    const shareTileImages = getImages('shareTileImages');

    return (
      <div className={`slay-it-forward ${mounted ? 'mounted': ''}`}>
        <MarketingPage>
          <MarketingSection className="MarketingSection-slay slay-banner-hero u-position--relative">
            <div className="clearfix">
              {bannerImages[0].map((imgPath)=>{
                return this.renderBackgroundImg(imgPath);
              })}
              <div className="main-slay-text hashtag-banner pull-left inner-buffer text-center">#SLAYITFORWARD</div>
              {bannerImages[1].map((imgPath)=>{
                return this.renderBackgroundImg(imgPath);
              })}
            </div>
          </MarketingSection>

          <MarketingSection className="MarketingSection-slay slay-reasoning inner-buffer">
            <div>
              { this.props.breakpoint === 'mobile' ? null :
                <h3 className='main-slay-text text-center font--secondary'>#SLAYITFORWARD</h3>
              }
              <p className="text-center">
                It’s a movement. <br/>
                In light of recent events, we feel it is our obligation and duty <br className="hidden-xs hidden-sm" />to remind women everywhere:
            </p>
            <p className="text-center font-medium">
              We are <em>capable</em>. We are <em>worthy</em>.<br /> We are more than our <em>bodies</em>,
              our <em>looks</em>, our <em>sex</em>. <br />We <em>slay</em>.
            </p>
            <p className="text-center">
              Let’s #SLAYITFORWARD.
            </p>
            <p className="text-center">
              Use the hashtag on Instagram to shout out a woman in your life who
              inspires you–or who needs <br className="hidden-xs hidden-sm" />some inspiration right now–and tell her how
              she slays. Now it’s her turn to #SLAYITFORWARD.<br />For every hashtag used,
              Fame and Partners will donate $1 to the charities below–ones that support
              <br className="hidden-xs hidden-sm" /> our most vulnerable, marginalized communities.
            </p>
            <p className="text-center">
              Join us in creating an unstoppable chain of women empowering women.
              Join us in donating to the <br className="hidden-xs hidden-sm" />people who need it most right now. Join us and
              <br />#SLAYITFORWARD.
              </p>
            </div>
          </MarketingSection>

          <MarketingSection className="MarketingSection-slay slay-organizations inner-buffer">
            <div className="slay-organizations-container text-center inner-buffer">
              <p className="font-large">The organizations <em>you're</em>&nbsp;supporting:</p>

              <p className="font--secondary text-uppercase title">American Civil Liberties Union (ACLU).</p>
              <p>They defend the individual rights and liberties guaranteed by the Constitution.</p>

              <p className="font--secondary text-uppercase title">Future Project.</p>
              <p>They help young people fulfill their potential and teach them skills they need for the future.</p>

              <p className="font--secondary text-uppercase title">Naral Pro-choice America.</p>
              <p>They advocate for women’s reproductive rights and freedom.</p>

              <p className="font--secondary text-uppercase title">National Immigration Law Center.</p>
              <p>They fight for the rights of low-income immigrants with litigation, policy analysis, and advocacy.</p>

              <p className="font--secondary text-uppercase title">National Organization for Women (NOW).</p>
              <p>They advocate for equal rights for women.</p>

              <p className="font--secondary text-uppercase title">Showing Up For Racial Justice.</p>
              <p>They are a national network of groups and individuals organizing white people for racial justice.</p>

              <p className="font--secondary text-uppercase title">Planned Parenthood.</p>
              <p>They are the nation’s leading sexual and reproductive healthcare provider.</p>

              <p className="font--secondary text-uppercase title">Rape, Abuse & Incest Network (RAINN).</p>
              <p>They are the largest anti-sexual violence organization in the country.</p>

              <p className="font--secondary text-uppercase title">Running Start.</p>
              <p>They educate young women about the importance of politics through the Young Women’s Political Leadership Program.</p>

              <p className="font--secondary text-uppercase title">She Should Run.</p>
              <p>They aim to get more women into elected positions of power.</p>

              <p className="font--secondary text-uppercase title">Sylvia Rivera Law Project.</p>
              <p>They provide legal service to low-income people and people of color who are transgender, intersexor otherwise gender non-conforming.</p>

              <p className="font--secondary text-uppercase title">Young Center for Immigrant Children’s Rights.</p>
              <p>They fight for the best interests of children who come to the U.S. on their own.</p>
            </div>
          </MarketingSection>

          <MarketingSection className="MarketingSection-slay slay-carousel clearfix">
            <div>
              <p className='text-center font-large'>Post, empower and <em>give back</em>.</p>
              <div className="insta-carousel clearfix">
                { this.props.breakpoint === 'mobile' ?
                  this.renderShareImgs(shareTileImages[0]) :
                  shareTileImages.map((imgPath)=>{
                    return this.renderShareImgs(imgPath)
                  })
                }
              </div>
            </div>
          </MarketingSection>

          <MarketingSection className="MarketingSection-slay slay-ceo-letter container hidden-sm hidden-xs">
            <div className="section-box row">
              <div className="item bordered col-md-6 col-md-offset-3">
                <div className="row vertical-align-row">
                  <div className="col-md-5 vertical-align img-side">
                    <img className='img-responsive' src={getImages('nyree')}></img>
                  </div>
                  <div className="col-md-7 vertical-align copy-side">
                    <div className="content-wrapper">
                      <p>
                        <h4 className="h1 no-margin-bottom">From our CEO.</h4>
                        A message from Nyree Corby, a female founder and CEO, to women everywhere.
                      </p>
                      <a href="/from-our-ceo">
                        <span className="cta-link-arrow-right"><span className="copy-highlight link-underline h5">Read Now</span><i className="icon icon-arrow-right"></i></span>
                      </a>
                    </div>
                  </div>
                </div>
              </div>
            </div>

          </MarketingSection>

          <MarketingSection className="MarketingSection-slay slay-ceo-letter inner-buffer hidden-lg hidden-md">
            <div className="text-center">
              <p className="font-large">From our CEO.</p>
              <img className='nyree-img' src={getImages('nyree')}></img>
              <p>A message from Nyree Corby, a female founder and CEO, to women everywhere.</p>
              <p className="font--secondary"><a href="/from-our-ceo"><span className='read-ceo-link u-textDecoration--underline'><strong>READ NOW</strong></span></a></p>
            </div>
          </MarketingSection>

      </MarketingPage>
    </div>
  );

  }
};

SlayItForward.propTypes = {
  breakpoint: PropTypes.string,
  dispatch: PropTypes.func.isRequired,
  SlayItForwardState: PropTypes.object
};

export default Resize(breakpoints)(connect(select)(SlayItForward));
