var LengthGuideModal = React.createClass({

  getInitialState: function() {
    return {
      'showing': 'inches',
      'metric': 'inches'
    };
  },

  handleShowMetric: function(metric) {
    var newState = $.extend({}, this.state);
    newState.showing = metric;
    this.setState(newState);
  },

  render: function() {
    var inchesClasses = classNames({
      'inches': true,
      'hidden': this.state.showing === 'inches'
    });

    var cmClasses = classNames({
      'cm': true,
      'hidden': this.state.showing === 'cm',
    });

    var tabInches = classNames({
      'pull-right': true,
      active: this.state.showing === 'inches'
    });

    var tabCm = classNames({
      'pull-left': true,
      active: this.state.showing === 'cm'
    });

    return (
      <div className="js-lenght-guide-modal modal lenght-guide-modal fade" id="modal-confirm" tabIndex='-1' role='dialog'>
        <div className="modal-vertical-align-helper">
          <div className="modal-dialog modal-vertical-align" role='document'>
            <div className="modal-content">
              <div className="modal-body">
                <div className="close-modal pull-right" data-dismiss="modal" aria-label="Close"></div>
                <div className="length-guide-container">
                  <div className="modal-body-container center-vertical text-center">
                    <h1>Height & Hemline Size Chart</h1>
                    <p>Skirt height is measured straight, from waist to hem and is based on wearing 5cm heels.</p>

                    <div className="actions">
                      <div className="col-xs-6 text-center tab-inches">
                        <a href="#" onClick={this.handleShowMetric.bind(this, 'inches')} className={tabInches} >inches</a>
                      </div>
                      <div className="col-xs-6 text-center">
                        <a href="#" onClick={this.handleShowMetric.bind(this, 'cm')} className={tabCm}>cm</a>
                      </div>
                    </div>

                    <table className="table table-desktop text-center">
                      <thead>
                        <tr><th>Type</th><th>Petite</th><th>Standard</th><th>Tall</th></tr>
                      </thead>
                      <tbody>
                        <tr className={inchesClasses}><td>Mini</td><td>16 ¾</td><td>17 ½</td><td>18 ¾</td></tr>
                        <tr className={inchesClasses}><td>Knee</td><td>21 ¼</td><td>22 ½</td><td>23 ¾</td></tr>
                        <tr className={inchesClasses}><td>Petti</td><td>26 ¾</td><td>28 ¼</td><td>29 ¾</td></tr>
                        <tr className={inchesClasses}><td>Midi</td><td>29 ½</td><td>31 ½</td><td>33 ½</td></tr>
                        <tr className={inchesClasses}><td>Ankle</td><td>37</td><td>39</td><td>41</td></tr>
                        <tr className={inchesClasses}><td>Maxi</td><td>41</td><td>43 ¼</td><td>45 ½</td></tr>
                        <tr className={cmClasses}><td>Mini</td><td>42.5</td><td>45</td><td>47.5</td></tr>
                        <tr className={cmClasses}><td>Knee</td><td>54</td><td>57</td><td>60</td></tr>
                        <tr className={cmClasses}><td>Petti</td><td>68</td><td>72</td><td>76</td></tr>
                        <tr className={cmClasses}><td>Midi</td><td>75</td><td>80</td><td>85</td></tr>
                        <tr className={cmClasses}><td>Ankle</td><td>94</td><td>99</td><td>104</td></tr>
                        <tr className={cmClasses}><td>Maxi</td><td>104</td><td>110</td><td>116</td></tr>
                      </tbody>
                    </table>
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
