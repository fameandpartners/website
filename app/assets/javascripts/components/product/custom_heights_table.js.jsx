var CustomHeightsTable = React.createClass({
  getInitialState: function(){
    return {
      displayMetric: true,
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
       <table className="heights_table">
         <caption>
           Show <span className={displayMetric ? 'active' : ''} onClick={this.setMetric}>Metric (cm) </span>
           <span className={displayImperial ? 'active' : ''} onClick={this.setImperial}>Inches </span>
           <span className={displayImperial && displayMetric ? 'active' : ''} onClick={this.setBoth}>Both</span>
         </caption>
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
   </table>)
  }
});

var SkirtHeightDataRow = React.createClass({
  render: function() {
    return(<tr>
      <th>{this.props.skirt.type}</th>
      {this.props.skirt.heights.map(function(size){
          return (
            <SkirtHeightValueCell key={size.cm} displayMetric={this.props.displayMetric} cm={size.cm} displayImperial={this.props.displayImperial} inches={size.inches}/>)
          }.bind(this))}
    </tr>);
  }
});

var SkirtHeightValueCell = React.createClass({
  render: function() {
    var metric    = this.props.displayMetric ? (<span className="cm">{this.props.cm}</span>) : "";
    var separator = (this.props.displayMetric && this.props.displayImperial) ? " / " : "";
    var imperial  = this.props.displayImperial ? (<span className="inches">{this.props.inches}</span>) : "";

    return (<td>{metric}{separator}{imperial}</td>);
  }
});
