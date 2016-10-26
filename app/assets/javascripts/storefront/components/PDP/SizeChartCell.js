import React, { Component } from 'react';

export default class SizeChartCell extends React.Component {
  parseFraction(value) {
    return (value + '').replace(/(\d+)\/(\d+)/, '<sup>$1</sup>/<sub>$2</sub>');
  }

  render() {
    return (
      <td className={this.props.className} dangerouslySetInnerHTML={{__html: this.parseFraction(this.props.value)}}></td>
    );
  }
}
