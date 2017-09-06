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
import autoBind from 'react-autobind';
import classnames from 'classnames';
import noop from '../../libs/noop';
import KEYS from '../../constants/keys';

// Components
import IconSVG from '../generic/IconSVG';

// CSS
import '../../../css/components/Select.scss';
import Carat from '../../../svg/carat.svg';

const propTypes = {
  id: PropTypes.string.isRequired,
  label: PropTypes.string,
  className: PropTypes.string,
  error: PropTypes.bool,
  options: PropTypes.arrayOf(PropTypes.shape({
    id: PropTypes.oneOfType([PropTypes.number, PropTypes.string]),
    name: PropTypes.oneOfType([PropTypes.string, PropTypes.node]),
    displayText: PropTypes.string,
    meta: PropTypes.oneOfType([PropTypes.number, PropTypes.string]),
    active: PropTypes.bool,
  })),
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
      selectedIndex: 0,
    };
    autoBind(this);

    // debounce to avoid onFocus & onClick from firing setState twice
    this.setDropdownState = _.debounce((state) => {
      this.setState({ isOpen: state });
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
        arrowFocusedIndex: this.state.selectedIndex,
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
        this.setState({ isOpen: true });
        if (index > 0) {
          this.setState({ arrowFocusedIndex: index - 1 });
        } else {
          this.setState({ arrowFocusedIndex: maxIndex });
        }
        return null;
      case KEYS.ARROW_DOWN:
        event.preventDefault();
        this.setState({ isOpen: true });
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
      this.setState({ selectedIndex: option.id });
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
      const anyItemFocused = (this.state.arrowFocusedIndex !== this.state.selectedIndex);

      return (
        <li
          ref={`options${index}`}
          key={`${this.props.id}-${option.id}`}
          data-value={option.meta}
          className={classnames(
            'Select__list-item u-user-select--none',
            {
              selected: option.active && !anyItemFocused,
              focused: isFocused,
            },
          )}
          onClick={this.handleDropdownItemClick(option)}
          aria-hidden={this.state.isOpen ? 'false' : 'true'}
        >
          {option.name}
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
        className={classnames(
          'Select--wrapper',
          className,
          {
            'Select--wrapper__error': error,
            'translate-label': label,
            'is-open': isOpen,
            'single-option': singleOption,
            'is-set': activeOption.active,
          },
        )}
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
        <IconSVG
          svgPath={Carat.url}
          className="Select__carat"
          width="15px"
          height="15px"
        />
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
