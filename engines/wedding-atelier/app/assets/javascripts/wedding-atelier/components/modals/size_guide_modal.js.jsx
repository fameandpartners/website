var SizeGuideModal = React.createClass({

  getInitialState: function() {
    return {
      metric: 'inches',
      measures: {
        inches: [
          ['0', '4', '32', '27', '25', '35'],
          ['2', '6', '33', '28', '26', '36'],
          ['4', '8', '34', '29', '27', '37'],
          ['6', '10', '35', '30', '28', '38'],
          ['8', '12', '36 ½', '31 ½', '29 ½', '39 ½'],
          ['10', '14', '38', '33', '31', '41'],
          ['12', '16', '39 ½', '34 ½', '32 ½', '42 ½'],
          ['14', '18', '41 ½', '36 ½', '34 ¾', '44 ¾'],
          ['16', '20', '43 ½', '38 ½', '37', '47'],
          ['18', '22', '45 ½', '40 ½', '39 ¼', '49 ¼'],
          ['20', '24', '47 ½', '42 ½', '41 ½', '51 ½'],
          ['22', '26', '49 ½', '44 ½', '43 ¾', '53 ¾'],
          ['24', '28', '51 ½', '46 ½', '46', '56'],
          ['26', '30', '53 ½', '48 ½', '48 ¼', '58 ¼']
        ],
        cm: [
          ['0','4','81','69','64','89'],
          ['2','6','84','71','66','92'],
          ['4','8','86','74','69','94'],
          ['6','10','89','76','71','97'],
          ['8','12','93','80','75','100'],
          ['10','14','97','84','79','104'],
          ['12','16','100','88','83','108'],
          ['14','18','105','93','88','114'],
          ['16','20','111','98','94','119'],
          ['18','22','116','103','100','125'],
          ['20','24','121','108','103','131'],
          ['22','26','126','113','111','137'],
          ['24','28','131','118','117','142'],
          ['26','30','136','124','123','148']
        ]
      },
      selectedTab: 'measure'
    };
  },

  changeMetric: function (metric) {
    this.setState({metric: metric});
  },

  renderMeasures: function () {
    var type = this.state.metric;
    if(this.state.measures[type]) {
      return this.state.measures[type].map(function (measure, row) {
        var rowKey = type + '-measure-' + row;
        return (
          <tr key={rowKey} className={type}>
            {
              measure.map(function (value, column) {
                var columnKey = type + '-measure-' + row + '-' + column;
                return <td key={columnKey}>{value}</td>;
              })
            }
          </tr>
        );
      });
    }
  },

  changeTab: function (to) {
    this.setState({selectedTab: to});
  },

  render: function() {
    var isMeasure = this.state.selectedTab === 'measure';
    var isTips = this.state.selectedTab === 'tips';
    var measuresTabClasses = classNames({
      'show-measure col-xs-6 text-center': true,
      'selected': isMeasure
    });

    var tipsTabClasses = classNames({
      'show-tips col-xs-6 text-center': true,
      'selected': isTips
    });

    var measureContainerClasses = classNames({
      'measure': true,
      'selected': isMeasure
    });

    var tipsContainerClasses = classNames({
      'tips': true,
      'selected': isTips
    });


    return(
      <div className="js-size-guide-modal modal size-guide-modal fade" id="modal-confirm" tabIndex="-1" role="dialog">
        <div className="modal-vertical-align-helper">
          <div className="modal-dialog modal-vertical-align" role="document">
            <div className="modal-content">
              <div className="modal-body">
                <div className="row">
                  <div className="col-xs-12">
                    <div className="close-modal pull-right" data-dismiss="modal" aria-label="Close" />
                  </div>
                </div>
                <div className="modal-body-container text-center">
                  <h1>
                    Size Guide
                  </h1>

                  <div className="container-fluid">
                    <div className="row">
                      <div className="col-xs-12 col-sm-6">
                        <div className="measure-actions" ref="actions">
                          <div className={measuresTabClasses} onClick={this.changeTab.bind(null, 'measure')}>
                            <a href="javascript:;">Where to measure</a>
                          </div>
                          <div className={tipsTabClasses} onClick={this.changeTab.bind(null, 'tips')}>
                            <a href="javascript:;">Measuring tips</a>
                          </div>
                        </div>

                        <div className={measureContainerClasses}>
                          <img src="/assets/wedding-atelier/tile-how-to-measure.jpg" />
                        </div>
                        <div className={tipsContainerClasses}>
                          <p>FYI - Your results will be the most accurate if someone else helps you measure!</p>
                          <p>Fame Tips</p>
                          <ul>
                            <li>Measure yourself in your underwear and, if possible, the bra you’d like to wear with the dress. Stand tall with your feet together.</li>
                            <li>If you plan on wearing heels with the dress, don’t forget to include heel height in your measurement! This will help you decide which of our three dress lengths - Petite, Standard, or Tall - is best for you.</li>
                          </ul>
                          <p>Bust - Measure around the fullest part of your chest, keeping the tape level to the floor.</p>
                          <p>Under-bust - Measure directly under your bust (around your rib cage, where your bra band sits), keeping the tape level to the floor.</p>
                          <p>Waist - Measure around your natural waistline (the smallest part of your waist).</p>
                          <p>Hips - Measure around the fullest part of your hips. Slim-hipped ladies can take this measurement from 20cm/8in below the waistline.</p>
                          <p>Dress Length - Stand with your heels together and measure from your shoulders to the floor, keeping the tape straight and perpendicular to the floor.</p>
                          <p>Skirt Length - Stand with your heels together and measure from your natural waistline to the floor, keeping the tape straight and perpendicular to the floor.</p>
                        </div>
                      </div>
                      <div className="size-guide-right col-xs-12 col-sm-6">
                        <p>Fame & Partners sizes are designed to fit the following measurements.</p>
                        <table className="measurements-table table table-condensed" ref="table">
                          <thead>
                            <tr>
                              <th colSpan="2">Sizing</th>
                              <th colSpan="3" className="text-center">Measurements</th>
                              <th className="measurement-system">

                              <form>
                                <input type="radio" name="radio_system" onClick={this.changeMetric.bind(null, 'inches')} id="radio_show_inches" defaultChecked={this.state.metric === 'inches'}  />
                                <label htmlFor="radio_show_inches"><span className="radio"></span> inches </label>

                                <input type="radio" name="radio_system" onClick={this.changeMetric.bind(null, 'cm')} id="radio_show_cm" defaultChecked={this.state.metric === 'cn'} />
                                <label htmlFor="radio_show_cm"><span className="radio"></span> cm</label>
                              </form>

                              </th>
                            </tr>
                          </thead>
                          <tbody className="measurement-table-body">
                            <tr>
                              <td>US</td>
                              <td>Aus/UK</td>
                              <td>Bust</td>
                              <td>Underbust</td>
                              <td>Waist</td>
                              <td>Hip</td>
                            </tr>
                            {this.renderMeasures()}
                          </tbody>
                        </table>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
});
