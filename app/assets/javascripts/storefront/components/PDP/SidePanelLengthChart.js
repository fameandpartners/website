import React, {PropTypes} from 'react';
import {connect} from 'react-redux';
import Tabs from 'react-simpletabs';

class SidePanelLengthChart extends React.Component {
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
    const triggerCopy = this.state.active ? 'Skirt Length Size Chart' : 'View the Skirt Length Size Chart';
    return (
      <div className="chart-wrap">
        <a href="javascript:;" className={triggerState} onClick={this.toggleMenu}>{triggerCopy}</a>
        <div className="inner-wrap">
          <p>Skirt length is measured straight, from waist to hem and is based on wearing 5cm heels.</p>
          <Tabs>
            <Tabs.Panel title="inches">
              <table className="table table-desktop text-center">
                <thead>
                  <tr>
                    <th>Type</th>
                    <th>Petite</th>
                    <th>Standard</th>
                    <th>Tall</th>
                  </tr>
                </thead>
                <tbody>
                  {this.props.skirts.map((item, index) => {
                    return (
                      <tr key={index}>
                        <td>{item.type}</td>
                        {item.heights.map((height, index) => {
                          return (
                            <td key={index}>{height.inches}</td>
                          );
                        })}
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </Tabs.Panel>

            <Tabs.Panel title="cm">
              <table className="table table-desktop text-center">
                <thead>
                  <tr>
                    <th>Type</th>
                    <th>Petite</th>
                    <th>Standard</th>
                    <th>Tall</th>
                  </tr>
                </thead>
                <tbody>
                  {this.props.skirts.map((item, index) => {
                    return (
                      <tr key={index}>
                        <td>{item.type}</td>
                        {item.heights.map((height, index) => {
                          return (
                            <td key={index}>{height.cm}</td>
                          );
                        })}
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

SidePanelLengthChart.propTypes = {
  skirts: PropTypes.array.isRequired
};

function mapStateToProps(state, ownProps) {
  return {
    skirts: state.skirts
  };
}

export default connect(mapStateToProps)(SidePanelLengthChart);
