var CustomHeightsTable = React.createClass({
  getInitialState: function(){
    return {
      displayMetric: false,
      displayImperial: true
    }
  },

  tableData: function() {
    return {
      skirts: [
        {
          type: 'Mini',
          heights: [
            {type: 'Petite',   cm: '42', inches: '16 ½'},
            {type: 'Standard', cm: '45', inches: '17 ¾'},
            {type: 'Tall',     cm: '48', inches: '19'}
          ]
        },
        {
          type: 'Knee',
          heights: [
            {type: 'Petite',   cm: '45.5', inches: '18'},
            {type: 'Standard', cm: '50',   inches: '19 ¾'},
            {type: 'Tall',     cm: '54.5', inches: '21 ½'}
          ]
        },
        {
          type: 'Petti',
          heights: [
            {type: 'Petite',   cm: '64', inches: '25'},
            {type: 'Standard', cm: '70', inches: '27 ½'},
            {type: 'Tall',     cm: '76', inches: '30'}
          ]
        },
        {
          type: 'Midi',
          heights: [
            {type: 'Petite',   cm: '72', inches: '28 ½'},
            {type: 'Standard', cm: '80', inches: '31 ½'},
            {type: 'Tall',     cm: '88', inches: '34 ½'}
          ]
        },
        {
          type: 'Maxi',
          heights: [
            {type: 'Petite',   cm: '102', inches: '40'},
            {type: 'Standard', cm: '112', inches: '44'},
            {type: 'Tall',     cm: '122', inches: '48'}
          ]
        }
      ]
    };
  },

  setMetric: function(){
    this.setState({displayImperial: false, displayMetric: true});
  },
  setImperial: function(){
    this.setState({displayImperial: true, displayMetric: false});
  },

  setBoth: function(){
    this.setState(this.getInitialState());
  },

  render: function(){
    var displayMetric   = this.state.displayMetric;
    var displayImperial = this.state.displayImperial;


    return (
      <div className='col-md-12'>
        <h2>SKIRT LENGTHS MEASUREMENT CHART</h2>
        <p>Skirt length is measured straight, from waist to hem and is based on wearing <CentimetresOrInches cm="5" inches="4" displayMetric={displayMetric} displayImperial={displayImperial} /> heels.</p>
        <ul className='list-unstyled list-inline'>
          <li>
            <a href='javascript:;' className={displayMetric ? 'active' : ''} onClick={this.setMetric}>CMs</a>
          </li>
          <li>
            <a href='javascript:;' className={displayImperial ? 'active' : ''} onClick={this.setImperial}>Inches</a>
          </li>
        </ul>
        <table className="table table-desktop table-striped table-bordered table-condensed">
          <thead>
            <tr>
              <th></th>
              <th>Petite</th>
              <th>Standard</th>
              <th>Tall</th>
            </tr>
          </thead>
          <tbody>
             {this.tableData().skirts.map(function(skirt){
                 return(<SkirtHeightDataRow key={skirt.type} skirt={skirt} displayMetric={displayMetric} displayImperial={displayImperial} />);
                 })}
          </tbody>
        </table>
      </div>
   )
  }
});

var SkirtHeightDataRow = React.createClass({
  render: function() {
    return(<tr>
      <th>{this.props.skirt.type}</th>
      {this.props.skirt.heights.map(function(size){
          return (
            <td key={size.cm}><CentimetresOrInches cm={size.cm} inches={size.inches} displayMetric={this.props.displayMetric} displayImperial={this.props.displayImperial} /></td>)
          }.bind(this))}
    </tr>);
  }
});

var CentimetresOrInches = React.createClass({
  render: function() {
    var metric    = this.props.displayMetric ? (<span className="cm">{this.props.cm}<sub>cm</sub></span>) : "";
    var separator = (this.props.displayMetric && this.props.displayImperial) ? " | " : "";
    var imperial  = this.props.displayImperial ? (<span className="inches">{this.props.inches}″</span>) : "";

    return (<span>{metric}{separator}{imperial}</span>);
  }
});
