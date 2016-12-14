var SizeSelector = React.createClass({
  propTypes: {
    sizes: React.PropTypes.array,
    heights: React.PropTypes.array,
    people: React.PropTypes.array,
    selectCallback: React.PropTypes.func.isRequired
  },

  componentDidMount: function(){
    $(this.refs.heightSelect)
      .select2({ minimumResultsForSearch: Infinity })
      .on('change', function(e){
        this.props.selectCallback('height', e.target.value);
      }.bind(this));
  },

  render: function() {

    var optionsForHeights = this.props.heights.map(function(height, index){
      return (
        <option key={index} value={height}>{height}</option>
      )
    });

    var dressSizes = this.props.sizes.map(function(size, index){
      return (
        <li key={index}>
          <input
            id={'size-'+index}
            type="radio"
            name="size"
            value={size}
            onClick={this.props.selectCallback.bind(null, 'size', size)}
             />
          <label htmlFor={'size-'+index}>{size}</label>
        </li>
      )
    }.bind(this));

    var peopleSizes = this.props.people.map(function(person, index){
      return (
        <li key={index}>
          <input
            id={'person-'+index}
            type="radio"
            name="size"
            value={person}
            onClick={this.props.selectCallback.bind(null, 'size', person)}
             />
          <label htmlFor={'person-'+index}>{person}</label>
        </li>
      )
    }.bind(this));

    return (
      <div ref="container" className="customization-selector animated slideInLeft">
        <div className="customization customization-size">
          <div className="customization-title">
            <h1><em>Tailor</em> to your body</h1>
            <p className="description">Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
          </div>
          <div className="form-group">
            <label htmlFor="heightSelect" className="text-left">Whats your height</label>
            <div>
              <select id="heightSelect" ref="heightSelect" className="form-control">
                { optionsForHeights }
              </select>
            </div>
          </div>
          <div className="form-group">
            <label>Whats your dress size &nbsp;</label><a href="#" className="guide-link hover-link">view size guide</a>
            <div className="dress-sizes">
              <ul className="customization-dress-sizes-ul">
                {dressSizes}
              </ul>
            </div>
          </div>
          <div className="form-group">
            <label>use one of the bridal parties size profiles</label>
            <div className="dress-sizes people-sizes">
              <ul className="customization-dress-sizes-ul people">
                {peopleSizes}
              </ul>
            </div>
          </div>
        </div>
      </div>
    );
  }
});
