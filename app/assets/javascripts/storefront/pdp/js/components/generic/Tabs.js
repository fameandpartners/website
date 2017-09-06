import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';
import autobind from 'react-autobind';
import classnames from 'classnames';

// CSS
import '../../../css/components/Tabs.scss';

/* eslint-disable react/prefer-stateless-function */
class Tabs extends PureComponent {
  constructor(props) {
    super(props);
    autobind(this);

    this.state = {
      selectedTabId: null,
    };
  }

  handleTabChange(clickedTab) {
    this.setState({
      selectedTabId: clickedTab,
    });
  }

  componentWillMount() {
    this.setState({
      // set initial tab on load
      selectedTabId: this.props.content[0].id,
    });
  }

  render() {
    const {
      content,
      headingClasses,
      contentClasses,
    } = this.props;

    const {
      selectedTabId,
    } = this.state;

    const selectedTabObj = content.filter(item => item.id === selectedTabId)[0];

    return (
      <div className="Tabs">
        <div
          className={classnames(
            'Tabs__heading',
            'Tabs__wrapper',
            headingClasses,
          )}
        >
          <ul className="Tabs__list">
            {content.map(
              item =>
                <li
                  key={item.id}
                  onClick={() => this.handleTabChange(item.id)}
                  className={classnames(
                    'Tabs__link',
                    {
                      'Tabs__link--active': item.id === selectedTabId,
                    },
                  )}
                >
                  {item.heading}
                </li>,
            )}
          </ul>
        </div>
        <div
          className={classnames(
            'Tabs__contents',
            contentClasses,
          )}
        >
          <div
            key={selectedTabObj.id}
            className="Tabs__panel"
          >
            {selectedTabObj.content}
          </div>
        </div>
      </div>
    );
  }
}

Tabs.propTypes = {
  content: PropTypes.arrayOf(PropTypes.shape({
    id: PropTypes.string,
    heading: PropTypes.string,
    content: PropTypes.shape({
    }),
  })).isRequired,
  headingClasses: PropTypes.string,
  contentClasses: PropTypes.string,
};

Tabs.defaultProps = {
  headingClasses: '',
  contentClasses: '',
};

export default Tabs;
