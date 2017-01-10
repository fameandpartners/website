var SizeSelector = React.createClass({
  propTypes: {
    siteVersion: React.PropTypes.string,
    sizes: React.PropTypes.array,
    heights: React.PropTypes.array,
    assistants: React.PropTypes.array,
    selectCallback: React.PropTypes.func.isRequired,
    currentCustomization: React.PropTypes.string,
    showContainers: React.PropTypes.object,
    currentUser: React.PropTypes.object
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
      that.heightSelectedHandle(e.target.value);
    }).val(this.state.assistant.user_profile.height);
  },

  parsePresentation: function(size) {
    var regexp = new RegExp(this.props.siteVersion + '(\\d+)', 'i');
    return size.name.match(regexp)[1];
  },

  heightSelectedHandle: function (height) {
    this.setState({
      assistant: null,
      height: height
    });
    if(this.state.size) {
      this.props.selectCallback('height', height);
      this.props.selectCallback('size', this.state.size);
    }
  },

  sizeSelectedHandle: function(size) {
    this.setState({
      assistant: null,
      size: size
    });
    if(this.state.height) {
      this.props.selectCallback('height', this.state.height);
      this.props.selectCallback('size', size);
    }
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
    this.props.selectCallback('size', assistant);
  },

  render: function() {
    var that = this;
    var optionsForHeights = this.props.heights.map(function(group) {
      var heights = group[1].map(function(height, index){
        return(<option key={index} height={height}>{height}</option>);
      });

      return (
        <optgroup key={group[0]} label={group[0]}>
          {heights}
        </optgroup>
      );
    });

    var dressSizes = this.props.sizes.map(function(size, index){
      var id = 'desktop-size-' + index,
          inputProps = {
            id: id,
            type: 'radio',
            name: 'desktop-size',
            value: size.name,
            onChange: that.sizeSelectedHandle.bind(null, size)
          };

      if (size.id === that.state.size.id || (that.state.assistant && size.id === that.state.assistant.user_profile.dress_size_id)) {
        inputProps.checked = true;
      }

      return (
        <li key={index}>
          <input {...inputProps} />
          <label htmlFor={id}>{that.parsePresentation(size)}</label>
        </li>
      );
    });

    var assistantsSizes = this.props.assistants.map(function(assistant, index){
      var id = 'desktop-assistant-' + index,
          inputProps = {
            id: id,
            type: 'radio',
            name: 'desktop-assistant',
            value: assistant.user_profile.dress_size,
            onChange: that.assistantSelectedHandle.bind(null, assistant)
          };

      if (that.state.assistant) {
        inputProps.checked = assistant.id === that.state.assistant.id;
      }

      return (
        <li key={index}>
          <input {...inputProps} />
          <label htmlFor={id}>{assistant.first_name}</label>
        </li>
      );
    });

    var customizationSelectorClasses = classNames({
      'customization-selector': true,
      'animated': true,
      'slideInLeft': this.props.showContainers.showSelector,
      'active': this.props.currentCustomization === 'size'
    });

    return (
      <div ref="container" className={customizationSelectorClasses}>
        <div className="customization customization-size">
          <div className="customization-title">
            <h1><em>Tailor</em> to your body</h1>
            <p className="description">Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
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
                <div>
                  {dressSizes}
                </div>
              </ul>
            </div>
          </div>
          <div className="form-group">
            <label>use one of the bridal parties size profiles</label>
            <div className="dress-sizes ungrouped large-labels">
              <ul className="customization-dress-sizes-ul people">
                <div>
                  {assistantsSizes}
                </div>
              </ul>
            </div>
          </div>
        </div>
      </div>
    );
  }
});
