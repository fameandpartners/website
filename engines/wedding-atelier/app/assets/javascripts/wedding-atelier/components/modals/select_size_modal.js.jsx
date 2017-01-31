var SelectSizeModal = React.createClass({
  propTypes: {
    current_user_id: React.PropTypes.number,
    dress: React.PropTypes.object,
    dressToAddToCart: React.PropTypes.number,
    eventSlug: React.PropTypes.number,
    heights: React.PropTypes.array,
    position: React.PropTypes.string,
    profiles: React.PropTypes.array,
    siteVersion: React.PropTypes.string,
    sizes: React.PropTypes.array,
    updateUserCartCallback: React.PropTypes.func
  },

  getInitialState: function(){
    return {
      useProfiles: true,
      selectedProfiles: [this.props.current_user_id],
      selectedSize: null,
      selectedHeight: null
     };
  },

  componentDidMount: function(){
    var that = this;
    $(this.refs.heightSelect).select2({
      minimumResultsForSearch: Infinity
    }).on('change', function (e) {
      that.heightSelectedHandle(e.target.value);
    });
  },

  profileSelectedHandle: function(profile){
    var _newState = $.extend({}, this.state),
        index = _newState.selectedProfiles.indexOf(profile.id);

    if(index > -1) {
      _newState.selectedProfiles.splice(index, 1);
    } else {
      _newState.selectedProfiles.push(profile.id);
    }
    _newState.selectedSize = null,
    _newState.selectedHeight = null,
    this.setState(_newState);
  },

  sizeSelectedHandle: function(size){
    var _newState = $.extend({}, this.state);
    _newState.selectedSize = size.id;
    _newState.selectedProfiles = [];
    this.setState(_newState);
  },

  heightSelectedHandle: function(height){
    var _newState = $.extend({}, this.state);
    _newState.selectedHeight = this.getHeightGroup(height);
    _newState.selectedProfiles = [];
    this.setState(_newState);
  },

  getHeightGroup: function(height){
    var heightGroup;
    this.props.heights.map(function(group){
      var index = group[1].indexOf(height);
      if(index > -1 ){
        heightGroup = group[0];
        return false;
      }
    });
    return heightGroup;
  },

  toggleSizes: function(){
    var _newState = $.extend({}, this.state);
    _newState.useProfiles = !this.state.useProfiles;
    this.setState(_newState);
  },

  cancel: function(){
    $(this.refs.modal).hide();
  },

  addToCartEnabled: function () {
    return this.state.selectedProfiles.length > 0 || this.state.selectedSize !== null && this.state.selectedHeight !== null;
  },

  handleAddToCart: function(profile) {
    var that = this;
    var attrs = {
      dress_id: this.props.dressToAddToCart,
      profiles: []
    };
    if(this.state.selectedProfiles.length) {
      attrs.profiles = this.state.selectedProfiles.map(function(id) {
        return {id: id};
      });
    } else {
      attrs.profiles = [{dress_size_id: this.state.selectedSize, height: this.state.selectedHeight}];
    }
    $.ajax({
      url: "/wedding-atelier/orders",
      type: "POST",
      dataType: "json",
      data: attrs,
      success: function (data) {
        that.props.updateUserCartCallback(data.order);
        $('#events__moodboard .js-select-size-modal').hide();
        $('.shopping-bag-container').trigger('shoppingBag:open');
      },
      error: function (response) {
        ReactDOM.render(<Notification errors={['Oops! There was an error adding your current customization to the shopping cart, try another combination.']} />,
            document.getElementById('notification'));
      }
    });
  },
  renderProfiles: function(){
    var that = this;
    var profiles = this.props.profiles.map(function(profile, index) {
      var name = 'cart-' + that.props.position +  '-profile-';
      var id = name + index;
      var inputProps = {
        id: id,
        type: 'checkbox',
        name: name,
        value: profile,
        onChange: that.profileSelectedHandle.bind(null, profile),
        defaultChecked: that.props.current_user_id === profile.id
      };

      return (
        <div key={index} className="col-xs-12 col-sm-6 col-md-6 text-center">
          <li>
            <input {...inputProps}/>
            <label htmlFor={id}>{profile.first_name}</label>
          </li>
        </div>
      );
    });

    var containerClasses = classNames({
      'profiles-container': true,
      'text-center': true,
      'dress-sizes': true,
      'large-labels': true,
      'no-margins': true,
      active: this.state.useProfiles
    });

    return(
      <div className={containerClasses}>
        <h1 className="title">Who is this dress for?</h1>
        <p className="instructions">Select as many names as you like, and we'll match the dress to your size profiles!</p>
        <ul className="row profiles">
          {profiles}
        </ul>
        <a href="#" className="select-different-size" onClick={this.toggleSizes}> or select different size </a>
        <div className="actions row">
          <div className="col-xs-12 col-sm-6">
            <button className="btn btn-gray" onClick={this.cancel}> Cancel </button>
          </div>
          <div className="col-xs-12 col-sm-6">
            <button className="btn btn-black" onClick={this.handleAddToCart} disabled={!this.addToCartEnabled()}> Add to cart </button>
          </div>
        </div>
      </div>
    );
  },

  renderSizes: function(){
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
      var name = that.props.position + '-size-',
          id = name + index,
          inputProps = {
            id: id,
            type: "radio",
            name: name,
            value: size.name,
            onChange: that.sizeSelectedHandle.bind(null, size)
          };

      return (
        <li key={index}>
          <input {...inputProps}/>
          <label htmlFor={id}>{PresentationHelper.sizePresentation(size)}</label>
        </li>
      );
    });

    var containerClasses = classNames({
      'sizes-container': true,
      'text-center': true,
      active: !this.state.useProfiles
    });

    return(
      <div className={containerClasses}>
        <h1>Tailor it to your body.</h1>
        <div className="size-selector-container">
          <div className="form-group text-left">
            <label htmlFor="heightSelect" className="text-left">Height:</label>
            <div>
              <select id="heightSelect" ref="heightSelect" className="form-control">
                {optionsForHeights}
              </select>
            </div>
          </div>
          <div className="form-group text-left">
            <label>Dress size &nbsp;</label><SizeGuideModalLauncher />
            <div className="dress-sizes ungrouped centered">
              <ul className="customization-dress-sizes-ul">
                {dressSizes}
              </ul>
            </div>
          </div>
          <div className="actions row">
            <div className="col-xs-12 col-sm-12 col-md-6">
              <button className="btn btn-gray" onClick={this.toggleSizes}>Return to bridal party</button>
            </div>
            <div className="col-xs-12 col-sm-12 col-md-6">
              <button className="btn btn-black" onClick={this.handleAddToCart} disabled={!this.addToCartEnabled()}>Add to cart</button>
            </div>
          </div>
        </div>
      </div>
    );
  },

  render: function(){
    var moodboardUrl = '/wedding-atelier/events/' + this.props.eventSlug;
    return(
      <div className="js-select-size-modal select-size-modal" ref="modal">
        <div className="body">
          <div className="close">
            <a className="btnClose icon-close-white"/>
          </div>
          <div className="content-container">
            {this.renderProfiles()}
            {this.renderSizes()}
          </div>
        </div>
      </div>
    );
  }
});
