var SizeSelectorMobile = React.createClass({
  propTypes: {
    siteVersion: React.PropTypes.string,
    sizes: React.PropTypes.array,
    heights: React.PropTypes.array,
    assistants: React.PropTypes.array,
    selectCallback: React.PropTypes.func.isRequired,
    showSizing: React.PropTypes.bool.isRequired,
    showSizingCallback: React.PropTypes.func.isRequired,
    currentUser: React.PropTypes.object.isRequired
  },

  getInitialState: function() {
    var user = $.extend({}, this.props.currentUser.user);
    return {
      assistant: user,
      height: user.user_profile.height,
      size: {}
    };
  },

  componentDidMount: function () {
    var that = this;
    $(this.refs.heightSelect).select2({
      placeholder: this.props.currentUser.user.user_profile.height,
      minimumResultsForSearch: Infinity
    }).on('change', function (e) {
      that.setState({
        assistant: null,
        height: e.target.value
      });
    }).val(this.state.assistant.user_profile.height);
  },

  close: function () {
    this.props.showSizingCallback(false);
  },

  parsePresentation: function(size) {
    // Finds the matching dress size depending the region US/AU, extracts the number
    var regexp = new RegExp(this.props.siteVersion + '(\\d+)', 'i');
    return size.name.match(regexp)[1];
  },

  heightSelectedHandle: function (height) {
    this.setState({
      assistant: null,
      height: height
    });
  },

  sizeSelectedHandle: function(size) {
    this.setState({
      assistant: null,
      size: size
    });
  },

  assistantSelectedHandle: function(assistant) {
    var size = this.props.sizes.filter(function (size) {
      return size.id === assistant.user_profile.dress_size_id;
    });
    $(this.refs.heightSelect).val(assistant.user_profile.height).trigger('change');
    this.setState({
      assistant: assistant,
      size: size[0],
      height: assistant.user_profile.height
    });
  },

  apply: function () {
    this.props.selectCallback('height', this.state.height);
    this.props.selectCallback('size', this.state.assistant || this.state.size);
    this.close();
  },

  render: function() {
    var that = this;

    var optionsForHeights = this.props.heights.map(function(group) {
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
      var id = 'mobile-size-' + index,
          inputProps = {
            id: id,
            type: "radio",
            name: "mobile-size",
            value: size.name,
            onChange: that.sizeSelectedHandle.bind(null, size)
          };

      if (size.id === that.state.size.id || (that.state.assistant && size.id === that.state.assistant.user_profile.dress_size_id)) {
        inputProps.checked = true;
      }

      return (
        <li key={index}>
          <input {...inputProps}/>
          <label htmlFor={id}>{that.parsePresentation(size)}</label>
        </li>
      );
    });

    var assistantsSizes = this.props.assistants.map(function(assistant, index) {
      var id = 'mobile-assistant-' + index;
      var inputProps = {
        id: id,
        type: 'radio',
        name: 'mobile-assistant',
        value: assistant,
        onChange: that.assistantSelectedHandle.bind(null, assistant)
      };

      if (that.state.assistant) {
        inputProps.checked = assistant.id === that.state.assistant.id;
      }

      return (
        <li key={index}>
          <input {...inputProps}/>
          <label htmlFor={id}>{assistant.first_name}</label>
        </li>
      );
    });

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
            <div className="dress-sizes ungrouped">
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
