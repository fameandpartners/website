import React, { Component } from 'react';
import PropTypes from 'prop-types';
import autoBind from 'react-autobind';

// Components
import Input from '../form/Input';

class SearchBar extends Component {
  constructor(props) {
    super(props);
    autoBind(this);
  }

  render() {
    const { onBlur } = this.props;
    return (
      <div
        className="SearchBar"
      >
        <Input
          id="dress_query"
          focusOnMount
          lineInput
          indent
          onBlur={onBlur}
        />
      </div>
    );
  }
}

SearchBar.propTypes = {
  onBlur: PropTypes.func.isRequired,
};

export default SearchBar;
