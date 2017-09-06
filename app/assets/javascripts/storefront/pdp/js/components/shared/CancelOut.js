/* eslint-disable react/prefer-stateless-function */
import React, { PureComponent } from 'react';

// CSS
import '../../../css/components/CancelOut.scss';

export default class CancelOut extends PureComponent {
  render() {
    return (
      <div
        className="CancelOut"
        role="button"
        {...this.props}
      />
    );
  }
}
