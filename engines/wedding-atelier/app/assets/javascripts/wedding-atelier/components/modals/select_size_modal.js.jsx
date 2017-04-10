var SelectSizeModal = React.createClass({
  propTypes: {
    current_user_id: React.PropTypes.number,
    dress: React.PropTypes.object,
    dressToAddToCart: React.PropTypes.object,
    eventId: React.PropTypes.number,
    heights: React.PropTypes.array,
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
      placeholder: 'Please select your height',
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
    this.setState(_newState);
  },

  sizeSelectedHandle: function(size){
    var _newState = $.extend({}, this.state);
    _newState.selectedSize = size.id;
    this.setState(_newState);
  },

  heightSelectedHandle: function(height){
    var _newState = $.extend({}, this.state);
    _newState.selectedHeight = this.getHeightGroup(height);
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

  cancel: function(e){
    e.stopPropagation();
    e.nativeEvent.stopImmediatePropagation();
    if($(e.target).hasClass('cancelable')){
      $(this.refs.modal).hide();
    }
  },

  addToCartAttrs: function () {
    var disabled = true;
    if(this.state.useProfiles){
      disabled = this.state.selectedProfiles.length === 0
    }else{
      disabled = this.state.selectedSize === null || this.state.selectedHeight === null
    }
    return {
      className: 'btn btn-black',
      onClick: this.handleAddToCart,
      disabled: disabled
    };
  },

  handleAddToCart: function(profile) {
    var that = this;
    var attrs = {
      dress_id: this.props.dressToAddToCart.id,
      profiles: []
    };
    if(this.state.useProfiles && this.state.selectedProfiles.length) {
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
        that.refs.notifications.notify(['Oops! There was an error adding your current customization to the shopping cart, try another combination.']);
      }
    });
  },
  renderProfiles: function(){
    var that = this;
    var profiles = this.props.profiles.map(function(profile, index) {
      var name = 'cart-profile';
      var id = name + index;
      var inputProps = {
        id: id,
        type: 'checkbox',
        name: name,
        value: profile,
        onChange: that.profileSelectedHandle.bind(null, profile),
        defaultChecked: that.state.selectedProfiles.indexOf(profile.id) > -1
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
            <button className="btn btn-gray cancelable" onClick={this.cancel}> Cancel </button>
          </div>
          <div className="col-xs-12 col-sm-6">
            <button {...this.addToCartAttrs()}> Add to cart </button>
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
      var name = 'cart-size',
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
          <label htmlFor={id}>{PresentationHelper.sizePresentation(size, that.props.siteVersion)}</label>
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
              <a href="#" className="back-to-size" onClick={this.toggleSizes}>Back to size profiles</a>
            </div>
            <div className="col-xs-12 col-sm-12 col-md-6">
              <button {...this.addToCartAttrs()}>Add to cart</button>
            </div>
          </div>
        </div>
      </div>
    );
  },

  renderPreview: function(){
    var dress = this.props.dressToAddToCart;
    if(dress){
      return(
        <div className="thumbnail-container">
          <img src={dress.images.front.thumbnail.grey}/>
          <div className="dress-info center-block">
            <strong>The {dress.title}</strong>
            <span>|</span>
            <span>{dress.price}</span>
          </div>
        </div>
      )
    }
  },

  render: function(){
    var moodboardUrl = '/wedding-atelier/events/' + this.props.eventId;
    return(
      <div className="js-select-size-modal select-size-modal cancelable" ref="modal" onClick={this.cancel}>
        <div className="body">
          <Notification ref="notifications"/>
          <a className="btnClose icon-close-white hidden-xs cancelable" onClick={this.cancel}/>
          <a className="btnClose icon-close hidden-sm hidden-md hidden-lg cancelable" onClick={this.cancel}/>
          <div className="content-container">
            <div className="col-sm-6 dress-preview text-center hidden-xs">
              {this.renderPreview()}
            </div>
            <div className="col-sm-6 size-options">
              {this.renderProfiles()}
              {this.renderSizes()}
            </div>
          </div>
        </div>
      </div>
    );
  }
});
