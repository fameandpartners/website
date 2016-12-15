var SizeSelector = React.createClass({
  propTypes: {
    siteVersion: React.PropTypes.object,
    sizes: React.PropTypes.array,
    heights: React.PropTypes.array,
    assistants: React.PropTypes.array,
    selectCallback: React.PropTypes.func.isRequired
  },

  componentDidMount: function(){
    $(this.refs.heightSelect)
      .select2({ minimumResultsForSearch: Infinity })
      .on('change', function(e){
        this.props.selectCallback('height', e.target.value);
      }.bind(this));
  },

  parsePresentation: function(size){
    var regexp = new RegExp(this.props.siteVersion.permalink + '(\\d+)', 'i')
    return size.name.match(regexp)[1];
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
            value={size.presentation}
            onClick={this.props.selectCallback.bind(null, 'size', size)}
             />
          <label htmlFor={'size-'+index}>{this.parsePresentation(size)}</label>
        </li>
      )
    }.bind(this));

    var assistantsSizes = this.props.assistants.map(function(assistant, index){
      return (
        <li key={index}>
          <input
            id={'person-'+index}
            type="radio"
            name="size"
            value={assistant.user_profile.dress_size}
            onClick={this.props.selectCallback.bind(null, 'size', assistant)}
             />
          <label htmlFor={'person-'+index}>{assistant.first_name}</label>
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
            <div className="dress-sizes assistants-sizes">
              <ul className="customization-dress-sizes-ul people">
                {assistantsSizes}
              </ul>
            </div>
          </div>
        </div>
      </div>
    );
  }
});
