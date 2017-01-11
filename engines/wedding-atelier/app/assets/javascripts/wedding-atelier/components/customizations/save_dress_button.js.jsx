var SaveDressButton = React.createClass({

  propTypes: {
    eventSlug: React.PropTypes.string,
    selectedOptions: React.PropTypes.object,
    mobile: React.PropTypes.bool
  },

  saveDress: function(){
    var url = '/wedding-atelier/events/:event_id/dresses'.replace(':event_id', this.props.eventSlug);
    $.ajax({
      type: 'POST',
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
    return size.id || size.user_profile.dress_size_id;
  },

  dressParams: function(){
    var options = this.props.selectedOptions,
        params = {
          product_id: this.tryIdFor(options.silhouette),
          fabric_id: this.tryIdFor(options.fabric),
          color_id: this.tryIdFor(options.colour),
          length_id: this.tryIdFor(options.length),
          style_id: this.tryIdFor(options.style),
          fit_id: this.tryIdFor(options.fit),
          size_id: this.sizeId(),
          height: options.height
        };
    return { event_dress: params };
  },

  successCallback: function(data){
    $('.modal-confirm').modal();
  },

  errorCallback: function(data){

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
