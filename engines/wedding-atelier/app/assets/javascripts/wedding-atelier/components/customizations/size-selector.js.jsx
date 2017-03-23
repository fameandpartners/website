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
      heightGroup: user.user_profile.height_group,
      size: user.user_profile.dress_size
    };
  },

  componentDidMount: function () {
    var that = this;
    $(this.refs.heightSelect).select2({
      placeholder: this.props.currentUser.user.user_profile.height,
      minimumResultsForSearch: Infinity
    }).on('change', function (e) {
      that.heightSelectedHandle(e.target);
    }).val(this.state.assistant.user_profile.height);
  },

  heightSelectedHandle: function (target) {
    // it's important to change size here to reset presentation as 4'10" / 147cm | 6
    // if previous size came from an user profile
    var height = target.value;
    var heightGroup = target.selectedOptions[0].parentElement.label;
    var _newState = $.extend({}, this.state);
    _newState.height = height;
    _newState.heightGroup = heightGroup;
    _newState.assistant = null;
    if(this.state.assistant){
      var size = this.state.assistant.user_profile.dress_size;
      this.props.selectCallback('size', size);
      _newState.size = size;
    }
    this.props.selectCallback('height', height);
    this.props.selectCallback('heightGroup', heightGroup);
    this.setState(_newState);
  },

  sizeSelectedHandle: function(size) {
    this.setState({
      assistant: null,
      size: size
    });
    this.props.selectCallback('size', size);
  },

  assistantSelectedHandle: function(assistant) {
    $(this.refs.heightSelect).val(assistant.user_profile.height).trigger('change');
    this.setState({
      assistant: assistant,
      size: assistant.user_profile.dress_size,
      height: assistant.user_profile.height,
      heightGroup: assistant.user_profile.height_group
    });
    this.props.selectCallback('size', assistant);
    this.props.selectCallback('height', assistant.user_profile.height);
    this.props.selectCallback('heightGroup', assistant.user_profile.heigh_group);
  },

  renderAssistants: function () {
    var that = this;
    return that.props.assistants.map(function(assistant, index){
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
      var id = 'desktop-size-' + index,
          inputProps = {
            id: id,
            type: 'radio',
            name: 'desktop-size',
            value: size.name,
            onChange: that.sizeSelectedHandle.bind(null, size)
          };

      if (size.id === that.state.size.id || (that.state.assistant && size.id === that.state.assistant.user_profile.dress_size.id)) {
        inputProps.checked = true;
      }

      return (
        <li key={index}>
          <input {...inputProps} />
          <label htmlFor={id}>{PresentationHelper.sizePresentation(size, that.props.siteVersion)}</label>
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
            <h1><em>Tailor</em> it to your body.</h1>
            <p className="description">All we need is your height and dress size to custom-make a dress that fits you perfectly.</p>
          </div>
          <div className="form-group">
            <label htmlFor="heightSelect" className="text-left">Height:</label>
            <div>
              <select id="heightSelect" ref="heightSelect" className="form-control">
                {optionsForHeights}
              </select>
            </div>
          </div>
          <div className="form-group">
            <label>Dress Size &nbsp;</label><SizeGuideModalLauncher />
            <div className="dress-sizes ungrouped">
              <ul className="customization-dress-sizes-ul">
                <div>
                  {dressSizes}
                </div>
              </ul>
            </div>
          </div>
          <div className="form-group">
            <label>Or, use one of the bridal party's size profiles.</label>
            <div className="dress-sizes ungrouped large-labels">
              <ul className="customization-dress-sizes-ul people">
                <div>
                  {this.renderAssistants()}
                </div>
              </ul>
            </div>
          </div>
        </div>
      </div>
    );
  }
});
