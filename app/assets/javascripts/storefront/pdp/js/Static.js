import React, { Component } from 'react';
import autoBind from 'react-autobind';

// Static Components

class Static extends Component {
  constructor(props) {
    super(props);
    autoBind(this);
  }

  render() {
    return (
      <div className="Static">
        This is some static Content
      </div>
    );
  }
}

export default Static;
