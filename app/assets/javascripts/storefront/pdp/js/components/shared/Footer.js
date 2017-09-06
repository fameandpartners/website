import React, { PureComponent } from 'react';
import autoBind from 'react-autobind';
import classNames from 'classnames';
// Components
import Button from '../generic/Button';
import Input from '../form/Input';

// CSS
import '../../../css/components/Footer.scss';

/* eslint-disable react/prefer-stateless-function */
class Footer extends PureComponent {
  constructor(props) {
    super(props);
    autoBind(this);
    this.state = {
      siteVersion: 'US',
      signupError: false,
    };
  }
  handleSignupClick(e) {
    e.preventDefault();
    // Simulate signup error
    this.setState({
      signupError: true,
    });
  }
  changeSiteVersion() {
    // Presentaional only, will actually change stuff in the future
    const { siteVersion } = this.state;
    if (siteVersion === 'AU') {
      this.setState({
        siteVersion: 'US',
      });
    } else {
      this.setState({
        siteVersion: 'AU',
      });
    }
  }

  render() {
    const { siteVersion, signupError } = this.state;
    return (
      <footer className="Footer">
        <div className="layout-container grid-noGutter-reverse-spaceAround">
          <ul className="col-2_sm-4 Footer__category-list">
            <li>
              <p className="Footer__category-title">Help</p>
            </li>
            <li>
              <p>
                <a href="/faqs#collapse-delivery-how-long">Shipping Info</a>
              </p>
            </li>
            <li>
              <p>
                <a href="/faqs#collapse-returns-policy">Returns Policy</a>
              </p>
            </li>
            <li>
              <p>
                <a href="/contact">Fame Contact Us</a>
              </p>
            </li>
            <li>
              <p>
                <a href="/faqs">FAQs</a>
              </p>
            </li>
            <li>
              <p>
                <a href="/size-guide">Size Guide</a>
              </p>
            </li>
            <li>
              <p>
                <a href="/faqs#collapse-orders-track">Track My Order</a>
              </p>
            </li>
          </ul>
          <ul className="col-2_sm-4 Footer__category-list">
            <li><p className="Footer__category-title">About</p></li>
            <li>
              <p>
                <a href="/why-us">Why shop with us</a>
              </p>
            </li>
            <li>
              <p>
                <a href="/about">About us</a>
              </p>
            </li>
            <li>
              <p>
                <a href="/fame-society-application">Fame Society</a>
              </p>
            </li>
            <li>
              <p>
                <a href="/from-our-ceo">From our CEO</a>
              </p>
            </li>
            <li>
              <p>
                <a href="/privacy">Privacy Policy</a>
              </p>
            </li>
            <li>
              <p>
                <a href="/terms">Terms</a>
              </p>
            </li>
          </ul>
          <ul className="col-2_sm-4_xs-0 Footer__category-list">
            <li><p className="Footer__category-title">Shop By</p></li>
            <li>
              <p>
                <a href="/dresses/best-sellers">Best Sellers</a>
              </p>
            </li>
            <li>
              <p>
                <a href="/dresses?order=newest">What's new</a>
              </p>
            </li>
            <li>
              <p>
                <a href="/getitquick">Made in 48 Hours</a>
              </p>
            </li>
            <li>
              <p>
                <a href="/dresses/formal">Formal</a>
              </p>
            </li>
            <li>
              <p>
                <a href="/dresses/prom">Prom</a>
              </p>
            </li>
            <li>
              <p>
                <a href="/dresses">View All Dresses</a>
              </p>
            </li>
          </ul>
          <div className="col-6_md-12_sm-12_sm-first u-mb-big">
            <p className="Footer__copy u-mb-small">
              Sign up to always enjoy free returns
            </p>
            <form className={classNames('grid-center', 'Footer__form')}>
              <div className="col-7_sm-9 padding--none">
                <div>
                  <Input
                    id="footer-email"
                    placeholder="Email your email address"
                    type="email"
                    error={signupError}
                    inlineMeta={signupError ? 'Error! Something is wrong...' : null}
                  />
                </div>
              </div>
              <div className="col-3 padding--none">
                <Button
                  className="padding--none"
                  handleClick={this.handleSignupClick}
                  text="Sign up"
                />
              </div>
            </form>
          </div>
        </div>
        <div className="layout-container grid-noGutter">
          <div className="col-12 Footer__site-version-container">
            <p className="u-user-select--none">Country: &nbsp;
              <span
                className="u-text-decoration--underline u-cursor--pointer"
                onClick={this.changeSiteVersion}
              >
                {siteVersion}
              </span>
            </p>
          </div>
        </div>
      </footer>
    );
  }
}

export default Footer;
