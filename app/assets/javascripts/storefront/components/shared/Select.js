/* eslint-disable */
//* ****
// ** Select is an abstract component for Fame and Partners dropdowns
// ** It requires an array to iterate over and build the options for the dropdown
// ** Format [{id: 0, name: 'Option One', active: false}, {id: 1, name: 'Option Two', active: false}, ... etc]
//* ****
import React from 'react';
import _ from 'lodash';
import autobind from 'auto-bind';
import keys from '../../constants/keys';
import { trackEvent } from '../../libs/gaTracking';
import { openHeightSelectEvent } from '../../libs/gaEventObjects';

// const propTypes = {
//   id: PropTypes.string,
//   label: PropTypes.string,
//   formId: PropTypes.string,
//   onChange: PropTypes.func,
//   className: PropTypes.string,
//   focusOnError: PropTypes.bool,
//   error: PropTypes.bool,
//   options: PropTypes.arrayOf(PropTypes.shape({
//     id: PropTypes.oneOfType([PropTypes.number, PropTypes.string]),
//     name: PropTypes.oneOfType([PropTypes.string, PropTypes.node]),
//     displayText: PropTypes.string,
//     meta: PropTypes.oneOfType([PropTypes.number, PropTypes.string]),
//     active: PropTypes.bool,
//   })),
// };

const defaultProps = {
  focusOnError: false,
  label: '',
  options: [],
};

class Select extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      isOpen: false,
      arrowFocusedIndex: -1,
    };
    autobind(this);

    // debounce to avoid onFocus & onClick from firing setState twice
    this.setDropdownState = _.debounce((state) => {
      this.setState({
        isOpen: state,
        arrowFocusedIndex: -1,
      });
    }, 250, true);
  }

  toggleDropdown() {
    !this.state.isOpen ? trackEvent(openHeightSelectEvent) : '';
    this.setDropdownState(!this.state.isOpen);
  }

  openDropdown() {
    if (!this.state.isOpen) {
      this.setDropdownState(true);
    }
  }

  closeDropdown() {
    if (this.state.isOpen) {
      this.setState({
        isOpen: false,
        arrowFocusedIndex: -1,
      });
    }
  }

  handleKeyboardActions(event) {
    const options = this.props.options || [];
    const maxIndex = options.length - 1;
    const index = this.state.arrowFocusedIndex;

    // handle keyboard up
    switch (event.keyCode) {
      case keys.ARROW_UP:
        event.preventDefault();
        if (index > 0) {
          this.setState({ arrowFocusedIndex: index - 1 });
        } else {
          this.setState({ arrowFocusedIndex: maxIndex });
        }
        break;
      case keys.ARROW_DOWN:
        event.preventDefault();
        if (index < maxIndex) {
          this.setState({
            arrowFocusedIndex: index + 1,
          });
        } else {
          this.setState({ arrowFocusedIndex: 0 });
        }
        break;
      case keys.ENTER:
        if (index >= 0 && index <= maxIndex) {
          this.handleDropdownItemClick(options[index])();
        }
        break;
      case keys.ESC:
        this.closeDropdown();
        break;
    }
  }

  handleDropdownItemClick(option) {
    return () => {
      this.closeDropdown();
      if (typeof this.props.onChange === 'function') {
        this.props.onChange({
          id: this.props.id,
          option,
        });
      }
    };
  }

  buildDropdown() {
    const options = this.props.options || [];

    const dropdownComponent = options.map((option, index) => {
      const isFocused = (this.state.arrowFocusedIndex === index);

      return (
        <li
          ref={`options${index}`}
          key={`${this.props.id}-${option.id}-${index}`}
          data-value={option.meta}
          className={`Select-list-item noSelect ${option.active ? 'selected' : ''} ${isFocused ? 'focused' : ''}`}
          onClick={this.handleDropdownItemClick(option)}
          aria-hidden={this.state.isOpen ? 'false' : 'true'}
        >
          {option.name}
        </li>
      );
    });

    return dropdownComponent;
  }


  generateClassName() {}

  componentDidUpdate(prevProps) {
    const { error, focusOnError } = this.props;
    if (error && !prevProps.error && focusOnError) {
      this.refs.selectWrapper.focus();
    }
  }

  render() {
    const {
      options,
      error,
      label,
      className,
    } = this.props;
    const { isOpen } = this.state;
    const contents = this.buildDropdown();
    const activeOption = _.find(options, { active: true }) || {};
    const spanText = activeOption.displayText || activeOption.name || label; // Waterfall of span text
    const singleOption = options.length === 1;
    return (
      <div
        className={`Select--wrapper ${className || ''} ${error ? 'Select--wrapper__error' : ''} ${label ? 'translate-label' : ''} ${isOpen ? 'is-open' : ''} ${singleOption ? 'single-option' : ''} ${activeOption.active ? 'is-set' : ''}`}
        ref="selectWrapper"
        onClick={this.toggleDropdown}
        onBlur={this.closeDropdown}
        onFocus={this.openDropdown}
        onKeyDown={this.handleKeyboardActions}
        tabIndex={isOpen ? '-1' : '0'}
      >
        {label
          ? <label className="Select-label noSelect">{label}</label>
          : null
        }
        <span className="Select-item-text noSelect">{spanText}</span>
        <div className="Select">
          <div className="Select-list-wrapper">
            <ul className="Select-list">
              {contents}
            </ul>
          </div>
        </div>
      </div>
    );
  }
}

// Select.propTypes = propTypes;
Select.defaultProps = defaultProps;

export default Select;
