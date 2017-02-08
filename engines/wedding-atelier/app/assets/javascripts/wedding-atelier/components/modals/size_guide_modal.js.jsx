var SizeGuideModal = React.createClass({

  getInitialState: function() {
    return {
      metric: 'inches'
    }
  },

  componentDidMount: function() {
    // TODO : Refactor all this $(this.refs.etc) to use state and classNames instead of jQuery

    $(this.refs.tips).hide();
    $(this.refs.table).find('.cm').hide();
  },

  handleShowMeasure: function() {
    $(this.refs.tips).hide();
    $(this.refs.measure).show();

    $(this.refs.actions).find('.show-tips').removeClass('selected');
    $(this.refs.actions).find('.show-measure').addClass('selected');
  },

  handleShowTips: function() {
    $(this.refs.tips).show();
    $(this.refs.measure).hide();

    $(this.refs.actions).find('.show-tips').addClass('selected');
    $(this.refs.actions).find('.show-measure').removeClass('selected');
  },

  handleShowCm: function() {
    $(this.refs.table).find('.cm').show();
    $(this.refs.table).find('.inches').hide();

    var nextState = $.extend({}, this.state);
    nextState.metric = 'cm';
    this.setState(nextState);
  },

  handleShowInches: function() {
    $(this.refs.table).find('.cm').hide();
    $(this.refs.table).find('.inches').show();

    var nextState = $.extend({}, this.state);
    nextState.metric = 'inches';
    this.setState(nextState);
  },

  render: function(){
    return(
      <div className="js-size-guide-modal modal size-guide-modal fade" id="modal-confirm" tabIndex='-1' role='dialog'>
        <div className="modal-vertical-align-helper">
          <div className="modal-dialog modal-vertical-align" role='document'>
            <div className="modal-content">
              <div className="modal-body">
                <div className="close-modal pull-right" data-dismiss="modal" aria-label="Close"></div>
                <div className="modal-body-container text-center">
                  <h1>
                    Size Guide
                  </h1>

                  <div className="container-fluid">
                    <div className="row">
                      <div className="col-xs-12 col-sm-6">
                        <div className="measure-actions" ref="actions">
                          <div className="show-measure col-xs-6 text-center selected">
                            <a href="#" onClick={this.handleShowMeasure}>Where to measure</a>
                          </div>
                          <div className="show-tips col-xs-6 text-center">
                            <a href="#" onClick={this.handleShowTips}>Measuring tips</a>
                          </div>
                        </div>

                        <div className="measure" ref="measure">
                          <img src="/assets/wedding-atelier/tile-how-to-measure.jpg" />
                        </div>
                        <div className="tips" ref="tips">
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
                      <div className="col-xs-12 col-sm-6">
                        <p>Fame & Partners sizes are designed to fit the following measurements.</p>

                        <table className="table table-condensed" ref="table">
                          <thead>
                            <tr>
                              <th colSpan="2">Sizing</th>
                              <th colSpan="3" className="text-center">Measurements</th>
                              <th className="measurementSystem">

                              <form>
                                <input type="radio" name="radio_system" onClick={this.handleShowInches} id="radio_show_inches" defaultChecked={this.state.metric === 'inches'}  />
                                <label htmlFor="radio_show_inches"><span className="radio"></span> inches </label>

                                <input type="radio" name="radio_system" onClick={this.handleShowCm} id="radio_show_cm" defaultChecked={this.state.metric === 'cn'} />
                                <label htmlFor="radio_show_cm"><span className="radio"></span> cm</label>
                              </form>

                              </th>
                            </tr>
                          </thead>
                          <tbody>
                            <tr>
                              <td>US</td>
                              <td>Aus/UK</td>
                              <td>Bust</td>
                              <td>Underbust</td>
                              <td>Waist</td>
                              <td>Hip</td>
                            </tr>
                            <tr className="inches"><td>0</td><td>4</td><td>32</td><td>27</td><td>25</td><td>35</td></tr>
                            <tr className="inches"><td>2</td><td>6</td><td>33</td><td>28</td><td>26</td><td>36</td></tr>
                            <tr className="inches"><td>4</td><td>8</td><td>34</td><td>29</td><td>27</td><td>37</td></tr>
                            <tr className="inches"><td>6</td><td>10</td><td>35</td><td>30</td><td>28</td><td>38</td></tr>
                            <tr className="inches"><td>8</td><td>12</td><td>36 ½</td><td>31 ½</td><td>29 ½</td><td>39 ½</td></tr>
                            <tr className="inches"><td>10</td><td>14</td><td>38</td><td>33</td><td>31</td><td>41</td></tr>
                            <tr className="inches"><td>12</td><td>16</td><td>39 ½</td><td>34 ½</td><td>32 ½</td><td>42 ½</td></tr>
                            <tr className="inches"><td>14</td><td>18</td><td>41 ½</td><td>36 ½</td><td>34 ¾</td><td>44 ¾</td></tr>
                            <tr className="inches"><td>16</td><td>20</td><td>43 ½</td><td>38 ½</td><td>37</td><td>47</td></tr>
                            <tr className="inches"><td>18</td><td>22</td><td>45 ½</td><td>40 ½</td><td>39 ¼</td><td>49 ¼</td></tr>
                            <tr className="inches"><td>20</td><td>24</td><td>47 ½</td><td>42 ½</td><td>41 ½</td><td>51 ½</td></tr>
                            <tr className="inches"><td>22</td><td>26</td><td>49 ½</td><td>44 ½</td><td>43 ¾</td><td>53 ¾</td></tr>
                            <tr className="inches"><td>24</td><td>28</td><td>51 ½</td><td>46 ½</td><td>46</td><td>56</td></tr>
                            <tr className="inches"><td>26</td><td>30</td><td>53 ½</td><td>48 ½</td><td>48 ¼</td><td>58 ¼</td></tr>
                            <tr className="cm"><td>0</td><td>4</td><td>81</td><td>69</td><td>64</td><td>89</td></tr>
                            <tr className="cm"><td>2</td><td>6</td><td>84</td><td>71</td><td>66</td><td>92</td></tr>
                            <tr className="cm"><td>4</td><td>8</td><td>86</td><td>74</td><td>69</td><td>94</td></tr>
                            <tr className="cm"><td>6</td><td>10</td><td>89</td><td>76</td><td>71</td><td>97</td></tr>
                            <tr className="cm"><td>8</td><td>12</td><td>93</td><td>80</td><td>75</td><td>100</td></tr>
                            <tr className="cm"><td>10</td><td>14</td><td>97</td><td>84</td><td>79</td><td>104</td></tr>
                            <tr className="cm"><td>12</td><td>16</td><td>100</td><td>88</td><td>83</td><td>108</td></tr>
                            <tr className="cm"><td>14</td><td>18</td><td>105</td><td>93</td><td>88</td><td>114</td></tr>
                            <tr className="cm"><td>16</td><td>20</td><td>111</td><td>98</td><td>94</td><td>119</td></tr>
                            <tr className="cm"><td>18</td><td>22</td><td>116</td><td>103</td><td>100</td><td>125</td></tr>
                            <tr className="cm"><td>20</td><td>24</td><td>121</td><td>108</td><td>103</td><td>131</td></tr>
                            <tr className="cm"><td>22</td><td>26</td><td>126</td><td>113</td><td>111</td><td>137</td></tr>
                            <tr className="cm"><td>24</td><td>28</td><td>131</td><td>118</td><td>117</td><td>142</td></tr>
                            <tr className="cm"><td>26</td><td>30</td><td>136</td><td>124</td><td>123</td><td>148</td></tr>
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
    )
  }
})
