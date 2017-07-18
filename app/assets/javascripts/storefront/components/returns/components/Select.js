//* ****
// ** Select is a dropdown component
// ** It requires an array to iterate over and build the options for the dropdown
// ** Format [
// {id: 0, name: 'Option One', active: false},
// {id: 1, name: 'Option Two', active: false}, ... etc]
//* ****
import React, { Component } from 'react';
import PropTypes from 'prop-types';
import _ from 'lodash';
import autoBind from 'auto-bind';
import noop from '../libs/noop';
import KEYS from '../constants/keys';

// CSS
import '../styles/Select.scss';
import Carat from '../svg/carat.svg';

const propTypes = {
  id: PropTypes.string.isRequired,
  label: PropTypes.string,
  className: PropTypes.string,
  error: PropTypes.bool,
  options: PropTypes.array,
  onChange: PropTypes.func,
};

const defaultProps = {
  className: '',
  error: false,
  label: '',
  options: [],
  onChange: noop,
};

class Select extends Component {

  constructor(props) {
    super(props);
    this.state = {
      isOpen: false,
      arrowFocusedIndex: -1,
    };
    autoBind(this);

    // debounce to avoid onFocus & onClick from firing setState twice
    this.setDropdownState = _.debounce((state) => {
      this.setState({
        isOpen: state,
        arrowFocusedIndex: -1,
      });
    }, 250, true);
  }

  toggleDropdown() {
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
      case KEYS.ARROW_UP:
        event.preventDefault();
        if (index > 0) {
          this.setState({ arrowFocusedIndex: index - 1 });
        } else {
          this.setState({ arrowFocusedIndex: maxIndex });
        }
        return null;
      case KEYS.ARROW_DOWN:
        event.preventDefault();
        if (index < maxIndex) {
          this.setState({
            arrowFocusedIndex: index + 1,
          });
        } else {
          this.setState({ arrowFocusedIndex: 0 });
        }
        return null;
      case KEYS.ENTER:
        if (index >= 0 && index <= maxIndex) {
          this.handleDropdownItemClick(options[index])();
        }
        return null;
      case KEYS.ESC:
        this.closeDropdown();
        return null;
      default:
        return null;
    }
  }

  handleDropdownItemClick(option) {
    return () => {
      this.closeDropdown();
      console.log("User chooses", option.displayText)
      this.props.onChange(option);
    };
  }

  buildDropdown() {
    const options = this.props.options || [];

    const dropdownComponent = options.map((option, index) => {
    const isFocused = (this.state.arrowFocusedIndex === index);
    const {isOpen} = this.state
      return (
        <li
          ref={`options${index}`}
          key={`${option.constantName}`}
          data-value={option.displayText}
          className='Select-list-item noSelect'
          onClick={this.handleDropdownItemClick(option)}
          aria-hidden={isOpen ? 'false' : 'true'}
        >
          {option.displayText}
        </li>
      );
    });

    return dropdownComponent;
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
    const spanText = activeOption.displayText || activeOption.name || label;
    const singleOption = options.length === 1;


    return (
      <div
        className={`Select--wrapper ${className || ''} ${error ? 'Select--wrapper__error' : ''} ${label ? 'translate-label' : ''} ${isOpen ? 'is-open' : ''} ${singleOption ? 'single-option' : ''} ${activeOption.active ? 'is-set' : ''}`}
        ref={c => this.selectWrapper = c}
        onClick={this.toggleDropdown}
        onBlur={this.closeDropdown}
        onFocus={this.openDropdown}
        onKeyDown={this.handleKeyboardActions}
        tabIndex={isOpen ? '-1' : '0'}
      >
        {label
          ? <span className="Select-label noSelect">{label}</span>
          : null
        }
        <span className="Select-item-text noSelect">{spanText}</span>
        <img src={Carat} alt="carat" className="Select__carat" width="15px" height="15px" />
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

Select.propTypes = propTypes;
Select.defaultProps = defaultProps;

export default Select;