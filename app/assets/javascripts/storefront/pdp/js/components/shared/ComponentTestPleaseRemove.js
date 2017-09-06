import React, { Component } from 'react';
import PropTypes from 'prop-types';
import autoBind from 'react-autobind';

// OTHER / TODO: REMOVE
import noop from '../../libs/noop';


// UI Global Components
import Input from '../form/Input';
import Select from '../form/Select';
import RadioToggle from '../form/RadioToggle';
import Button from '../generic/Button';


// import { connect } from 'react-redux';
// import { bindActionCreators } from 'redux';

// Actions
// import * as AppActions from '../../actions/AppActions';

// CSS
import '../../../css/components/Slider.scss';

// Assets

// function stateToProps(state) {
//   // Which part of the Redux global state does our component want to receive as props?
//   return {
//     sideMenuOpen: state.$$appState.get('sideMenuOpen'),
//   };
// }
//
// function dispatchToProps(dispatch) {
//   const actions = bindActionCreators(AppActions, dispatch);
//   return {
//     activateSideMenu: actions.activateSideMenu,
//   };
// }

class Slider extends Component {
  constructor(props) {
    super(props);
    autoBind(this);
  }

  render() {
    return (
      <div className="layout-container typography ui-component-section grid-12">
        <div className="col-12">
          <h2>UI Global Components</h2>
          <button onClick={this.handleActivateModal}>Open Sign Up Modal</button>
        </div>
        <div className="col-4">
          <pre>Input.js</pre>
          <Input
            id="test-input"
          />
        </div>
        <div className="col-4">
          <pre>Select.js</pre>
          <Select
            id="test-select"
            label="Choose Something"
            options={[
              { id: 0, name: 'Option One', active: false },
              { id: 1, name: 'Option Two', active: false },
            ]}
          />
        </div>
        <div className="col-4">
          <pre>RadioToggle.js</pre>
          <RadioToggle
            id="test-select"
            label="Choose Something"
            value="INCHES"
            options={[
              { label: 'in', value: 'INCHES' },
              { label: 'cm', value: 'CM' },
            ]}
            onChange={noop}
          />
        </div>
        <hr className="col-12" />
        <div className="col-4">
          <pre>Button.js</pre>
          <Button
            text="Fame Button"
            handleClick={noop}
          />
        </div>
      </div>
    );
  }
}

Slider.propTypes = {
  sideMenuOpen: PropTypes.bool,
};

Slider.defaultProps = {
  sideMenuOpen: false,
};

export default Slider;
