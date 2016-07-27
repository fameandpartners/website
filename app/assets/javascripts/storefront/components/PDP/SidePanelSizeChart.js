import React, {PropTypes} from 'react';
import {connect} from 'react-redux';
import Tabs from 'react-simpletabs';

class SidePanelSizeChart extends React.Component {
  constructor(props, context) {
    super(props, context);

    this.state = {
      active: false
    };

    this.toggleMenu = this.toggleMenu.bind(this);
  }

  toggleMenu() {
    if(this.state.active) {
      this.setState({active: false});
    } else {
      this.setState({active: true});
    }
  }

  render() {
    const triggerState = this.state.active ? 'chart-wrap-trigger is-active' : 'chart-wrap-trigger';
    const triggerCopy = this.state.active ? 'Size Chart' : 'View the Size Chart';
    return (
      <div className="chart-wrap">
        <a href="javascript:;" className={triggerState} onClick={this.toggleMenu}>{triggerCopy}</a>
        <div className="inner-wrap">
          <p>
            Measurements are much more accurate if taken by someone else.
            For more information about our sizing, visit our <a href="/size-guide" target="_blank">sizing guide</a>.</p>
          <Tabs>
            <Tabs.Panel title="US">
              <table className="table table-desktop text-center">
                <thead>
                  <tr>
                    <th>Sizes</th>
                    <th>Bust</th>
                    <th>Underbust</th>
                    <th>Waist</th>
                    <th>Hip</th>
                  </tr>
                </thead>
                <tbody>
                  {this.props.sizeChart.map((row, index) => {
                    let dataArray = new Array;
                    for(let obj in row) {
                      dataArray.push(row[obj]);
                    }
                    return (
                      <tr key={index}>
                        <td>{dataArray[1]}</td>
                        <td>{dataArray[3]}</td>
                        <td>{dataArray[5]}</td>
                        <td>{dataArray[7]}</td>
                        <td>{dataArray[9]}</td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </Tabs.Panel>

            <Tabs.Panel title="AUS/UK">
              <table className="table table-desktop text-center">
                <thead>
                  <tr>
                    <th>Sizes</th>
                    <th>Bust</th>
                    <th>Underbust</th>
                    <th>Waist</th>
                    <th>Hip</th>
                  </tr>
                </thead>
                <tbody>
                  {this.props.sizeChart.map((row, index) => {
                    let dataArray = new Array;
                    for(let obj in row) {
                      dataArray.push(row[obj]);
                    }
                    return (
                      <tr key={index}>
                        <td>{dataArray[0]}</td>
                        <td>{dataArray[2]}</td>
                        <td>{dataArray[4]}</td>
                        <td>{dataArray[6]}</td>
                        <td>{dataArray[8]}</td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </Tabs.Panel>
          </Tabs>
        </div>
      </div>
    );
  }
}

SidePanelSizeChart.propTypes = {
  sizeChart: PropTypes.array.isRequired
};

function mapStateToProps(state, ownProps) {
  return {
    sizeChart: state.sizeChart
  };
}

export default connect(mapStateToProps)(SidePanelSizeChart);
