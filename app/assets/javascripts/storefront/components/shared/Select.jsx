//*****
// ** Select is an abstract component for Fame and Partners dropdowns
// ** It requires an array to iterate over and build the options for the dropdown
// ** Format [{id: 0, name: 'Option One', active: false}, {id: 1, name: 'Option Two', active: false}, ... etc]
//*****
import React, {Component, PropTypes} from 'react';
import _ from 'lodash';
import autobind from 'auto-bind';

const propTypes = {
    id: React.PropTypes.string,
    formId: React.PropTypes.string,
    onChange: React.PropTypes.func,
    label: React.PropTypes.string,
    className: React.PropTypes.string,
    options: React.PropTypes.arrayOf(React.PropTypes.shape({
        name: React.PropTypes.oneOfType([React.PropTypes.string, React.PropTypes.node,]),
        id: React.PropTypes.oneOfType([React.PropTypes.number, React.PropTypes.string,]),
        active: React.PropTypes.bool,
    })),
};

const defaultProps = {
    label: '',
    options: [],
};

class Select extends Component {

    constructor (props) {
        super(props);
        this.state = {
            isOpen: false,
            arrowFocusedIndex: -1,
        };
        autobind(this);

        // debounce to avoid onFocus & onClick from firing setState twice
        const self = this;
        this.setDropdownState = _.debounce(function(state) {
            self.setState({
              isOpen: state,
              arrowFocusedIndex: -1,
            });
        }, 250, true).bind(this);
    }

    toggleDropdown () {
        this.setDropdownState(!this.state.isOpen);
    }

    openDropdown () {
        if (!this.state.isOpen) {
            this.setDropdownState(true);
        }
    }

    closeDropdown () {
        if (this.state.isOpen) {
            this.setState({
              isOpen: false,
              arrowFocusedIndex: -1,
            });
        }
    }

    handleKeyboardActions (event) {
        const options = this.props.options || [];
        const maxIndex = options.length - 1;
        const index = this.state.arrowFocusedIndex;

        // handle keyboard up
        switch (event.keyCode) {
        case 38:
            event.preventDefault();
            if (index > 0) {
                this.setState({arrowFocusedIndex: index - 1,});
            } else {
                this.setState({arrowFocusedIndex: maxIndex,});
            }
            break;
        case 40:
            event.preventDefault();
            if (index < maxIndex) {
                this.setState({arrowFocusedIndex: index + 1,});
            } else {
                this.setState({arrowFocusedIndex: 0,});
            }
            break;
        case 13:
            if (index >= 0 && index <= maxIndex) {
                this.handleDropdownItemClick(options[index])();
            }
            break;
        case 27:
            this.closeDropdown();
            break;
        }
    }


    handleDropdownItemClick (option) {
        return () => {
            this.closeDropdown();
            if (typeof this.props.onChange === 'function') {
                this.props.onChange(this.props.id, option.id, this.props.formId, option);
            }
        };
    }

    buildDropdown () {
        const self = this;
        const options = this.props.options || [];

        const dropdownComponent =  options.map(function(option, index) {
            const isFocused = (self.state.arrowFocusedIndex === index);

            return (
                <li ref={`options${index}`}
                    key={`${self.props.id}-${option.id}-${index}`}
                    data-value={option.id}
                    data-display-text={option.name}
                    className={`${option.active ? 'selected' : ''} ${isFocused ? 'focused' : ''} Select-list-item noSelect`}
                    onClick={self.handleDropdownItemClick(option)}
                    aria-hidden={self.state.isOpen ? 'false' : 'true'}
                >
                    {option.name}
                </li>
            );
        });

        return dropdownComponent;
    }

    render () {
        const { options, label, className, } = this.props;
        const { isOpen,} = this.state;
        const contents = this.buildDropdown();
        const activeOption = _.find(options, {active:true,}) || {};
        const spanText = activeOption.displayText || activeOption.name || label; // Waterfall of span text
        const singleOption = options.length === 1;
        return (
            <div
                className={`Select-wrapper ${className || ''} ${label ? 'translate-label': ''} ${isOpen ? 'is-open' : ''} ${singleOption ? 'single-option' : ''} ${activeOption.active ? 'is-set' : ''}`}
                ref="selectWrapper"
                onClick={this.toggleDropdown}
                onBlur={this.closeDropdown}
                onFocus={this.openDropdown}
                onKeyDown={this.handleKeyboardActions}
                tabIndex={isOpen ? '-1' : '0'}
            >
                {label ? <label className="Select-label noSelect">{label}</label> : null}
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

Select.propTypes = propTypes;
Select.defaultProps = defaultProps;


module.exports = Select;
