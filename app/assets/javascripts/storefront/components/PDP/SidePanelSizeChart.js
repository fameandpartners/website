import React, {PropTypes} from 'react';
import {connect} from 'react-redux';
import Tabs from 'react-simpletabs';
import Modal from 'react-modal';

class SidePanelSizeChart extends React.Component {
  constructor(props, context) {
    super(props, context);

    this.state = {
      active: false,
      modalIsOpen: false,
      imchesIsActive: true,
      cmIsActive: false
    };

    this.openModal = this.openModal.bind(this);
    this.closeModal = this.closeModal.bind(this);
    this.showInches = this.showInches.bind(this);
    this.showCm = this.showCm.bind(this);
  }

  openModal() {
    this.setState({modalIsOpen: true});
  }

  closeModal() {
    this.setState({modalIsOpen: false});
  }

  showCm() {
    this.setState({
      imchesIsActive: false,
      cmIsActive: true
    });
  }

  showInches() {
    this.setState({
      imchesIsActive: true,
      cmIsActive: false
    });
  }

  render() {
    const TRIGGER_COPY = this.state.active ? 'View New Size Guide' : 'View Legacy Size Guide';
    const INCHES_IS_ACTIVE = this.state.imchesIsActive ? 'is-active' : '';
    const CM_IS_ACTIVE = this.state.cmIsActive ? 'is-active' : '';
    // this is just reset, proper styling will be applied through SASS
    const MODAL_STYLE = {
      overlay: {
        backgroundColor: null
      },
      content: {
        position: null,
        top: null,
        left: null,
        right: null,
        bottom: null,
        border: null,
        background: null,
        overflow: null,
        WebkitOverflowScrolling: null,
        borderRadius: null,
        padding: null
      }
    };

    return (
      <div className="chart-wrap">
        <a href="javascript:;" className="chart-wrap-trigger" onClick={this.openModal}>{TRIGGER_COPY}</a>

        <Modal
          style={MODAL_STYLE}
          isOpen={this.state.modalIsOpen}
          onRequestClose={this.closeModal}>
          <div className="pdp-sizeguide">
            <div className="row">
              <div className="col-md-12">
                {(() => {
                  if(this.props.sizeChartVersion === "2016") {
                    return (
                      <h4 className="h2 title text-center">Legacy size guide</h4>
                    );
                  } else {
                    return (
                      <h4 className="h2 title text-center">Size guide</h4>
                    );
                  }
                })()}
              </div>
              <div className="col-md-6">
                <Tabs>
                  <Tabs.Panel title="Where to measure">
                    <div className="media-wrap">
                      <img src="/assets/_pdp/tile-how-to-measure.jpg"
                        alt="Where to measure - Bust, Underbust, Waist, Hips" />
                    </div>
                  </Tabs.Panel>
                  <Tabs.Panel title="Measuring tips">
                    <p>FYI - Your results will be the most accurate if someone else helps you measure!</p>
                    <h5 className="heading"><em>Fame Tips</em></h5>
                    <p>- Measure yourself in your underwear and, if possible, the bra you’d like to wear with the dress.
                      Stand tall with your feet together.<br/>- If you plan on wearing heels with the dress, don’t forget
                      to include heel height in your measurement! This will help you decide which of our three dress
                      lengths - Petite, Standard, or Tall - is best for you.</p>
                    <p><span>Bust</span> - Measure around the fullest part of your chest, keeping the tape level to the floor.</p>
                    <p><span>Under-bust</span> - Measure directly under your bust (around your rib cage, where your bra band sits), keeping the tape level to the floor.</p>
                    <p><span>Waist</span> - Measure around your natural waistline (the smallest part of your waist).</p>
                    <p><span>Hips</span> - Measure around the fullest part of your hips. Slim-hipped ladies can take this measurement from 20cm/8in below the waistline.</p>
                    <p><span>Dress Length</span> - Stand with your heels together and measure from your shoulders to the floor, keeping the tape straight and perpendicular to the floor.</p>
                    <p><span>Skirt Length</span> - Stand with your heels together and measure from your natural waistline to the floor, keeping the tape straight and perpendicular to the floor.</p>
                  </Tabs.Panel>
                </Tabs>
              </div>
              <div className="col-md-6">
                <p className="table-title text-center">Fame & Partners sizes are designed to fit the following measurements.</p>
                <table>
                  <thead>
                    <tr>
                      <th className="divider" colSpan="2">Sizing</th>
                      <th colSpan="4">
                        Measurements
                        <span className="toggle-controls">
                          <a href="javascript:;"
                            className={"toggle-selector " + INCHES_IS_ACTIVE}
                            onClick={this.showInches}>inches</a>
                          <a href="javascript:;"
                            className={"toggle-selector " + CM_IS_ACTIVE}
                            onClick={this.showCm}>cm</a>
                        </span>
                      </th>
                    </tr>
                    <tr>
                      <th>US</th>
                      <th className="divider">Aus/UK</th>
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
                        <tr key={index} className={INCHES_IS_ACTIVE}>
                          <td>{dataArray[1]}</td>
                          <td className="divider">{dataArray[0]}</td>
                          <td>{dataArray[3]}</td>
                          <td>{dataArray[5]}</td>
                          <td>{dataArray[7]}</td>
                          <td>{dataArray[9]}</td>
                        </tr>
                      );
                    })}
                    {this.props.sizeChart.map((row, index) => {
                      let dataArray = new Array;
                      for(let obj in row) {
                        dataArray.push(row[obj]);
                      }
                      return (
                        <tr key={index} className={CM_IS_ACTIVE}>
                          <td>{dataArray[1]}</td>
                          <td className="divider">{dataArray[0]}</td>
                          <td>{dataArray[2]}</td>
                          <td>{dataArray[4]}</td>
                          <td>{dataArray[6]}</td>
                          <td>{dataArray[8]}</td>
                        </tr>
                      );
                    })}
                  </tbody>
                </table>
              </div>
            </div>
          </div>
          <a href="javascript:;" className="btn-close lg" onClick={this.closeModal}>
            <span className="hide-visually">Close Menu</span>
          </a>
        </Modal>
      </div>
    );
  }
}

SidePanelSizeChart.propTypes = {
  sizeChart: PropTypes.array.isRequired,
  sizeChartVersion: PropTypes.string.isRequired
};

function mapStateToProps(state, ownProps) {
  return {
    sizeChart: state.sizeChart,
    sizeChartVersion: state.product.size_chart
  };
}

export default connect(mapStateToProps)(SidePanelSizeChart);
