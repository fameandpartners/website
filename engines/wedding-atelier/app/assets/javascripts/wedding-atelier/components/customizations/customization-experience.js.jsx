var CustomizationExperience = React.createClass({
  propTypes: {
    customizationsUrl: React.PropTypes.string,
    siteVersion: React.PropTypes.string,
    eventSlug: React.PropTypes.string,
    currentUser: React.PropTypes.object,
    event_name: React.PropTypes.string,
    event_path: React.PropTypes.string,
    edit: React.PropTypes.bool,
    initialDress: React.PropTypes.object
  },

  getInitialState: function() {
    return {
      currentCustomization: null,
      subTotal: 0,
      customizationsCost: 0,
      customizations: {
        silhouettes: [],
        fabrics: [],
        colours: [],
        lengths: [],
        styles: [],
        fits: [],
        sizes: [],
        assistants: [],
        heights: []
      },
      selectedOptions: {
        silhouette: null,
        fabric: null,
        colour: null,
        length: null,
        style: null,
        fit: null,
        size: null,
        height: null
      }
    };
  },

  componentWillMount: function(){
    $.get(this.props.customizationsUrl, function(data){
      if(this.props.edit){
        this.prepareEditDress(data.customization, this.props.initialDress.event_dress)
      }else{
        this.prepareNewDress(data.customization);
      }
    }.bind(this));
  },

  prepareEditDress: function(customization, dress){
    var newState = $.extend({}, this.state)
    newState.customizations = customization;
    newState.selectedOptions.silhouette = dress.product;
    newState.selectedOptions.fabric = dress.fabric;
    newState.selectedOptions.colour = dress.color;
    newState.selectedOptions.length = dress.length;
    newState.selectedOptions.size = dress.size;
    newState.selectedOptions.height = dress.height;
    newState.selectedOptions.fit = dress.fit;
    newState.selectedOptions.style = dress.style;
    newState.customizations.fits = dress.product.fits;
    newState.customizations.styles = dress.product.styles;
    newState.subTotal = parseInt(dress.product.price);
    newState.customizationsCost = this.customizationsCost();
    this.setState(newState);
  },

  prepareNewDress: function(customization){
    var newState = $.extend({}, this.state),
        silhouette = customization.silhouettes[0],
        fabric = _.findWhere(customization.fabrics, { name: 'HG'}),
        colour = _.findWhere(customization.colours, { name: 'berry' }),
        length = _.findWhere(customization.lengths, { name: 'AK' });
    newState.customizations = customization;
    newState.selectedOptions.silhouette = silhouette
    newState.selectedOptions.fabric = fabric;
    newState.selectedOptions.colour = colour;
    newState.selectedOptions.length = length;
    newState.selectedOptions.size = this.props.currentUser.user;
    newState.selectedOptions.height = this.props.currentUser.user.user_profile.height;
    newState.customizations.fits = silhouette.fits;
    newState.customizations.styles = silhouette.styles;
    newState.subTotal = parseInt(silhouette.price);
    newState.customizationsCost = this.customizationsCost();
    this.setState(newState);
  },

  customizationsCost: function(){
    var selectedOptions = this.state.selectedOptions,
        cost = 0;

    for(var key in selectedOptions) {
      var option = selectedOptions[key];
      if(key !== 'size' && key !== 'silhouette' && key !== 'height' && option) {
        cost += parseInt(option.price);
      }
    }
    return cost;
  },

  changeCurrentCustomizationCallback: function(currentCustomization){
    this.setState({ currentCustomization: currentCustomization });
  },

  selectCallback: function(customization, value){
    var newState = $.extend({}, this.state);
    newState.selectedOptions[customization] = value;
    newState.customizationsCost = this.customizationsCost();

    if(customization === 'silhouette' && value) {
      newState.customizations.styles = value.styles;
      newState.customizations.fits = value.fits;
    }
    this.setState(newState);
  },

  startOverCallback: function () {
    this.setState({selectedOptions: {
      silhouette: null,
      fabric: null,
      colour: null,
      length: null,
      style: null,
      fit: null,
      size: null,
      height: ''
    }});
  },

  editDesignCallback: function () {
    $('.customization-experience--mobile .js-slick-hook').slick('slickGoTo', 1);
  },

  render: function(){
    var props = {
      selectedOptions: this.state.selectedOptions,
      currentCustomization: this.state.currentCustomization,
      customizations: this.state.customizations,
      changeCurrentCustomizationCallback: this.changeCurrentCustomizationCallback,
      selectCallback: this.selectCallback,
      startOverCallback: this.startOverCallback,
      siteVersion: this.props.siteVersion,
      subTotal: this.state.subTotal,
      customizationsCost: this.state.customizationsCost,
      eventSlug: this.props.eventSlug,
      currentUser: this.props.currentUser,
      event_name: this.props.event_name,
      event_path: this.props.event_path
    };

    return (
      <div className="customization-experience container-fluid">
        <MobileCustomizations {...props} />
        <DesktopCustomizations {...props} />
        <CustomizationsModal
          siteVersion={this.props.siteVersion}
          selectedOptions={this.state.selectedOptions}
          editDesignCallback={this.editDesignCallback}/>
        <SaveDressModal
          eventSlug={this.props.eventSlug}
        />
      </div>
    );
  }
});
