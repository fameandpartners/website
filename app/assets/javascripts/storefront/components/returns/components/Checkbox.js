import React, { Component } from 'react';
import classNames from 'classnames';

class Checkbox extends Component {
  constructor(props) {
    super(props);
    this.handleChange = this.handleChange.bind(this);
  }

  handleChange(e) {
    const { onChange } = this.props;
    onChange();
  }

  render() {
    const {
      id,
      wrapperClassName,
      checkboxStatus,
      showForm
    } = this.props;
    return (
      <div>
        { showForm
          ? (
           <div
             className={classNames(
               'Checkbox__wrapper',
               wrapperClassName,
             )}
           >
             <input className="Checkbox" id={id} type="checkbox" checked={checkboxStatus} onChange={this.handleChange} />
             <label htmlFor={id}></label>
           </div>
          )
          : null
        }
      </div>
    )
  }
}

export default Checkbox;
