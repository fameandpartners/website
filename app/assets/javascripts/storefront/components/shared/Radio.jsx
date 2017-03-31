//*****
// ** Radio is an abstracted child component for Fame and Partners Radio selections
//*****
import React, {Component, PropTypes,} from 'react';

const propTypes = {
  id: React.PropTypes.string,
};

class Radio extends Component {
  constructor(props) {
    super(props);
  }

  render() {
    const {name, selectedValue, onChange,} = this.context.radioGroup;
    const optional = {};
    if(selectedValue !== undefined) {
      optional.checked = (this.props.value === selectedValue);
    }
    if(typeof onChange === 'function') {
      optional.onChange = onChange.bind(null, this.props.value);
    }

    return (
      <input
        {...this.props}
        type="radio"
        name={name}
        {...optional} />
    );
  }
}

Radio.propTypes = propTypes;
Radio.contextTypes = {
  radioGroup: React.PropTypes.object,
};

export default Radio;
