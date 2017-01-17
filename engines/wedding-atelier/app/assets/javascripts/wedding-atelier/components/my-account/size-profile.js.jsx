var SizeProfile = React.createClass({
  propTypes: {
    user: React.PropTypes.object.isRequired,
    sizes: React.PropTypes.array.isRequired,
    heights: React.PropTypes.object.isRequired,
    siteVersion: React.PropTypes.string.isRequired
  },

  getInitialState: function () {
    return {
      size: {},
      height: {}
    };
  },

  componentDidMount: function () {
    $(this.refs.heightSelect)
      .select2({ minimumResultsForSearch: Infinity });
  },

  parsePresentation: function (size) {
    var dressSizeZoneRegexp = new RegExp(this.props.siteVersion + '(\\d+)', 'i');
    return size.option_value.name.match(dressSizeZoneRegexp)[1];
  },

  changeSizeHandler: function (size) {
    this.setState({size: size.option_value.id});
  },

  changeHeightHandler: function (evt) {
    var height = evt.target.selectedOptions[0].value;
    this.setState({height: height});
  },

  renderHeightOptions: function () {
    return Object.keys(this.props.heights).map(function (group, index) {
      var heights = this.props.heights[group].map(function (height, index) {
        return <option key={index} value={height}>{height}</option>;
      });

      return <optgroup key={group} label={group}>{heights}</optgroup>;
    }.bind(this));
  },

  renderDressSizes: function () {
    return this.props.sizes.map(function (size, index) {
      var id = 'size-profile-option' + index;
      return (
        <li key={index}>
          <input id={id}
            type="radio"
            name="size"
            value={size.option_value.name}
            onClick={this.changeSizeHandler.bind(null, size)}/>
          <label htmlFor={id}>{this.parsePresentation(size)}</label>
        </li>
      );
    }.bind(this));
  },

  render: function () {
    return (
      <div className="size-profile">
        <div className="customization-title">
          <h1><em>Update,</em> your size profile.</h1>
        </div>
        <div className="form-group">
          <label htmlFor="heightSelect" className="text-left">Height</label>
          <div>
            <select id="heightSelect" ref="heightSelect" className="form-control" onChange={this.changeHeightHandler}>
              {this.renderHeightOptions()}
            </select>
          </div>
        </div>
        <div className="form-group">
          <label>Dress size &nbsp;</label>(<a href="#" className="guide-link hover-link">view size guide</a>)
          <div className="dress-sizes centered">
            <ul className="customization-dress-sizes-ul">
              {this.renderDressSizes()}
            </ul>
          </div>
        </div>
      </div>
    );

  }

});
