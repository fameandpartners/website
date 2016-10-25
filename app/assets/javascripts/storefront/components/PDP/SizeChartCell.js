import React, { Component } from 'react';

export default class SizeChartCell extends React.Component {
  parseFraction(value) {
    let match = (value + '').match(/(\d+)\/(\d+)/);
    if (match) {
      value = value.replace(match[0], `<sup>${match[1]}</sup>/<sub>${match[2]}</sub>`);
    }

    return value;
  }

  render() {
    return (
      <td dangerouslySetInnerHTML={{__html: this.parseFraction(this.props.value)}}></td>
    );
  }
}
