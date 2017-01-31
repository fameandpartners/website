var SaveDressButton = React.createClass({

  propTypes: {
    eventSlug: React.PropTypes.string,
    selectedOptions: React.PropTypes.object,
    mobile: React.PropTypes.bool,
    edit: React.PropTypes.bool,
    initialDress: React.PropTypes.object,
    currentUser: React.PropTypes.object
  },

  saveDress: function(){
    if(this.props.edit && this.isSameUser()){
      this.updateDress();
    }else{
      this.createDress();
    }
  },

  isSameUser: function(){
    return this.props.currentUser.user.id === this.props.initialDress.user.id;
  },

  eventPath: function(){
    return '/wedding-atelier/events/:event_id/dresses'.replace(':event_id', this.props.eventSlug);
  },

  createDress: function(){
    $.ajax({
      type: 'POST',
      url: this.eventPath(),
      dataType: 'json',
      data: this.dressParams(),
      success: this.successCallback,
      error: this.errorCallback
    });
  },

  updateDress: function(){
    var url = this.eventPath() + '/' + this.props.initialDress.id;
    $.ajax({
      type: 'PUT',
      url: url,
      dataType: 'json',
      data: this.dressParams(),
      success: this.successCallback,
      error: this.errorCallback
    });
  },

  tryIdFor: function(customization){
    return customization ? customization.id : null;
  },

  sizeId: function(){
    var size = this.props.selectedOptions.size;
    if(!size){ return null; }
    if(size.user_profile){
      return size.user_profile.dress_size.id;
    }else{
      return size.id;
    }
  },

  dressParams: function(){
    var options = this.props.selectedOptions,
        params = {
          product_id: this.tryIdFor(options.silhouette),
          fabric_id: this.tryIdFor(options.fabric),
          color_id: this.tryIdFor(options.color),
          length_id: this.tryIdFor(options.length),
          style_id: this.tryIdFor(options.style),
          fit_id: this.tryIdFor(options.fit),
          size_id: this.sizeId(),
          height: options.height
        };
    return { event_dress: params };
  },

  successCallback: function(data){
    $('.js-save-dress-modal').modal();
  },

  errorCallback: function(data){
    jsonData = JSON.parse(data.responseText)
    ReactDOM.render(<Notification errors={jsonData.errors} />, $('#notification')[0]);
  },

  render: function() {
    var buttonClass = this.props.mobile ? 'btn-gray':'btn-transparent';
    return (
      <button className={buttonClass} onClick={this.saveDress}>
       save this dress
       </button>
     );
  }
});
