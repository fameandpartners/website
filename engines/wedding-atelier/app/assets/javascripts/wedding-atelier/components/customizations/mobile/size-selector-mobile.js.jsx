var SizeSelectorMobile = React.createClass({
  propTypes: {
    siteVersion: React.PropTypes.string,
    sizes: React.PropTypes.array,
    heights: React.PropTypes.array,
    assistants: React.PropTypes.array,
    selectCallback: React.PropTypes.func.isRequired,
    showSizing: React.PropTypes.bool.isRequired,
    showSizingCallback: React.PropTypes.func.isRequired
  },

  getInitialState: function() {
    return {
      assistantSelected: false,
      height: null,
      size: {}
    };
  },

  componentWillMount: function() {
    $(this.refs.heightSelect)
      .select2({ minimumResultsForSearch: Infinity })
      .on('change', function(e) {
        this.props.selectCallback('height', e.target.value);
        if(this.state.assistantSelected){
          $('input[name="assistant"]').removeProp('checked');
          // this following line is in order to reset if the menu shows the user name
          // or a size no
          this.props.selectCallback('size', { name: $('input[name="size"]:checked').val() });
          this.setState({assistantSelected: false});
        }
      }.bind(this));
  },

  componentDidMount: function () {
    $(this.refs.heightSelect).select2();
  },

  close: function () {
    this.setState({
      assistantSelected: false,
      height: null,
      size: {}
    });
    $(this.refs.container).find(':checked').prop('checked', false);
    this.props.showSizingCallback(false);
  },

  parsePresentation: function(size) {
    // Finds the matching dress size depending the region US/AU, extracts the number
    var regexp = new RegExp(this.props.siteVersion + '(\\d+)', 'i');
    return size.name.match(regexp)[1];
  },

  setSizeWithProfile: function(assistant) {
    var newState = {};

    $(this.refs.container).find('input[value="' + assistant.user_profile.dress_size + '"]').prop('checked', true);
    $(this.refs.heightSelect).select2().val(assistant.user_profile.height).change();
    newState.size = assistant;
    newState.assistantSelected = true;
    this.setState(newState);
    this.changeHeight();
  },

  changeSize: function(size) {
    $('input[name="assistant"]').removeProp('checked');
    this.setState({size: size});
    this.changeHeight();
  },

  changeHeight: function () {
    var height = $(ReactDOM.findDOMNode(this.refs.heightSelect)).val();
    this.setState({height: height});
  },

  apply: function () {
    this.props.selectCallback('height', this.state.height);
    this.props.selectCallback('size', this.state.size);
  },

  render: function() {

    var optionsForHeights = this.props.heights.map(function(group){
      var heights = group[1].map(function(height, index){
        return(<option key={index} value={height}>{height}</option>);
      });

      return (
        <optgroup key={group[0]} label={group[0]}>
          {heights}
        </optgroup>
      );
    });

    var dressSizes = this.props.sizes.map(function(size, index){
      var id = 'mobile-size-' + index;
      return (
        <li key={index}>
          <input
            id={id}
            type="radio"
            name="size"
            value={size.name}
            onClick={this.changeSize.bind(null, size)}
             />
          <label htmlFor={id}>{this.parsePresentation(size)}</label>
        </li>
      );
    }.bind(this));

    var assistantsSizes = this.props.assistants.map(function(assistant, index) {
      var id = 'mobile-assistant-' + index;

      return (
        <li key={index}>
          <input
            id={id}
            type="radio"
            name="assistant"
            value={assistant.user_profile.dress_size}
            onClick={this.setSizeWithProfile.bind(this, assistant)}
             />
          <label htmlFor={id}>{assistant.first_name}</label>
        </li>
      );
    }.bind(this));

    var containerClasses = classNames({
      'customization-selector-mobile-size': true,
      'js-customization-size-selector-mobile-size': true,
      'animate': this.props.showSizing
    });

    return (
      <div ref="container" className={containerClasses}>
        <div className="customization-selector-mobile-header">
          <i className="icon icon-size"></i>
          <div className="selector-name text-left">Size</div>
          <div className="selector-close" onClick={this.close}></div>
        </div>
        <div className="customization-selector-mobile-size-body">
          <div className="customization-title">
            <h1><em>Tailor</em> to your body</h1>
          </div>
          <div className="form-group">
            <label htmlFor="heightSelect" className="text-left">Whats your height</label>
            <div>
              <select id="heightSelect" ref="heightSelect" className="form-control">
                {optionsForHeights}
              </select>
            </div>
          </div>
          <div className="form-group">
            <label>Whats your dress size &nbsp;</label><a href="#" className="guide-link hover-link">view size guide</a>
            <div className="dress-sizes ungrouped centered">
              <ul className="customization-dress-sizes-ul">
                {dressSizes}
              </ul>
            </div>
          </div>
          <div className="form-group">
            <label>use a size profile</label>
            <div className="dress-sizes ungrouped large-labels">
              <ul className="customization-dress-sizes-ul people">
                {assistantsSizes}
              </ul>
            </div>
          </div>
        </div>
        <div className="customizations-selector-mobile-actions-double">
          <button className="btn-gray" onClick={this.close}>cancel</button>
          <button className="btn-black" onClick={this.apply}>apply</button>
        </div>
      </div>
    );
  }
});
