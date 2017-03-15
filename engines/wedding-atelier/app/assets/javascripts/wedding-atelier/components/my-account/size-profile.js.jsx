var SizeProfile = React.createClass({
  propTypes: {
    user: React.PropTypes.object.isRequired,
    user1: React.PropTypes.object,
    sizes: React.PropTypes.array.isRequired,
    heights: React.PropTypes.object.isRequired,
    siteVersion: React.PropTypes.string.isRequired,
    account_profile_path: React.PropTypes.string.isRequired,
    user_profile: React.PropTypes.object.isRequired
  },

  getInitialState: function () {
    var userProfile = $.extend({}, this.props.user_profile.user_profile);
    return {
      size_id: userProfile.dress_size.id,
      height: userProfile.height,
      userProfile:  userProfile
    };
  },

  componentDidMount: function () {
    var that = this;
    $(this.refs.heightSelect).select2({
      minimumResultsForSearch: Infinity
    }).val(this.state.userProfile.height)
    .on('change', function (e) {
      that.changeHeightHandler(e.target.value);
    }).trigger('change');
  },

  changeSizeHandler: function (size) {
    this.setState({
      size_id: size.option_value.id,
      userProfile: null
    });
  },

  changeHeightHandler: function (height) {
    this.setState({height: height});
  },

  renderHeightOptions: function () {
    return Object.keys(this.props.heights).map(function (group, index) {
      var heights = this.props.heights[group].map(function (height, index) {
        return <option key={height + index} value={height}>{height}</option>;
      });

      return <optgroup key={group + index} label={group}>{heights}</optgroup>;
    }.bind(this));
  },

  renderDressSizes: function () {
    var that = this;
    return this.props.sizes.map(function (size, index) {
      var id = 'size-profile-option-' + index,
          inputProps = {
            id: id,
            type: 'radio',
            name: 'size',
            value: size.name,
            onChange: that.changeSizeHandler.bind(null, size)
          };

      if (size.option_value.id === that.state.size_id || (that.state.userProfile && size.option_value.id === that.state.userProfile.dress_size.id)) {
        inputProps.checked = true;
      }

      return (
        <li key={index}>
          <input {...inputProps}/>
          <label htmlFor={id}>{PresentationHelper.sizePresentation(size.option_value, that.props.siteVersion)}</label>
        </li>
      );
    }.bind(this));
  },

  sizeProfileSavedHandle: function(e){
    e.preventDefault();
    var state = $.extend({}, this.state);
    var payload = {
      account: {
        user_profile_attributes: {
          id: this.props.user_profile.id,
          height: state.height,
          dress_size_id: state.size_id}
      }
    };
    var notificationNode = document.getElementById('notification');
    $.ajax({
      url: this.props.account_profile_path,
      type: 'PUT',
      dataType: 'json',
      data: payload,
      success: function (response) {
        ReactDOM.unmountComponentAtNode(notificationNode);
        ReactDOM.render(<Notification errors={['Changes successfully saved']} />, notificationNode);
      },
      error: function (data) {
        ReactDOM.unmountComponentAtNode(notificationNode);
        ReactDOM.render(<Notification errors={JSON.parse(data.responseText).errors} />, notificationNode);
      }
    });

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
            <select id="heightSelect" ref="heightSelect" className="form-control">
              {this.renderHeightOptions()}
            </select>
          </div>
        </div>
        <div className="form-group">
          <SizeGuideModal />
          <label>Dress size &nbsp;</label><SizeGuideModalLauncher />
          <div className="dress-sizes centered">
            <ul className="customization-dress-sizes-ul">
              {this.renderDressSizes()}
            </ul>
          </div>
        </div>
        <div className="col-sm-12 text-center">
          <button className="btn-black" onClick={this.sizeProfileSavedHandle}>Save</button>
        </div>
      </div>
    );

  }

});
