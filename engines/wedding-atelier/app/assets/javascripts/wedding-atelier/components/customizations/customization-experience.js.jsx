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
        colors: [],
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
        color: null,
        length: null,
        style: null,
        fit: null,
        size: null,
        height: null,
        heightGroup: null,
        customized: false
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
    var newState = $.extend({}, this.state);
    newState.customizations = customization;
    newState.selectedOptions.silhouette = dress.product;
    newState.selectedOptions.fabric = dress.fabric;
    newState.selectedOptions.color = dress.color;
    newState.selectedOptions.length = dress.length;
    newState.selectedOptions.size = dress.size;
    newState.selectedOptions.height = dress.height;
    newState.selectedOptions.fit = dress.fit;
    newState.selectedOptions.style = dress.style;
    newState.customizations.fits = dress.product.fits;
    newState.customizations.styles = dress.product.styles;
    newState.customizations.fabrics = dress.product.fabrics;
    newState.customizations.lengths = dress.product.lengths;
    newState.subTotal = parseInt(dress.product.price);
    newState.customizationsCost = this.customizationsCost();
    this.setState(newState);
  },

  prepareNewDress: function(customization){
    var newState = $.extend({}, this.state),
        silhouette = customization.silhouettes[0],
        fabric = _.findWhere(silhouette.fabrics, { name: 'HG'}),
        color = _.findWhere(customization.colors, { name: 'berry' }),
        length = _.findWhere(silhouette.lengths, { name: 'AK' });
    newState.customizations = customization;
    newState.selectedOptions.silhouette = silhouette;
    newState.selectedOptions.fabric = fabric;
    newState.selectedOptions.color = color;
    newState.selectedOptions.length = length;
    newState.selectedOptions.size = this.props.currentUser.user.user_profile.dress_size;
    newState.selectedOptions.height = this.props.currentUser.user.user_profile.height;
    newState.selectedOptions.heightGroup = this.props.currentUser.user.user_profile.height_group;
    newState.customizations.fits = silhouette.fits;
    newState.customizations.styles = silhouette.styles;
    newState.customizations.fabrics = silhouette.fabrics;
    newState.customizations.lengths = silhouette.lengths;
    newState.subTotal = parseInt(silhouette.price);
    newState.customizationsCost = this.customizationsCost();
    this.setState(newState);
  },

  customizationsCost: function(){
    var selectedOptions = this.state.selectedOptions,
        cost = 0;

    for(var key in selectedOptions) {
      var option = selectedOptions[key];
      var hasCustomPrice = ['fit', 'style'].indexOf(key) >= 0;
      if(hasCustomPrice && option) {
        cost += parseFloat(option.price);
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
      var fabric = _.findWhere(value.fabrics, { name: newState.selectedOptions.fabric.name }),
          length = _.findWhere(value.lengths, { name: newState.selectedOptions.length.name });

      newState.selectedOptions.fabric = fabric;
      newState.selectedOptions.length = length;
      newState.customizations.styles = value.styles;
      newState.customizations.fits = value.fits;
      newState.customizations.fabrics = value.fabrics;
      newState.customizations.lengths = value.lengths;
    }

    //Flag needed to whether add the previously saved dress or customized params
    newState.selectedOptions.customized = true;
    this.setState(newState);
  },

  startOverCallback: function () {
    this.setState({selectedOptions: {
      silhouette: null,
      fabric: null,
      color: null,
      length: null,
      style: null,
      fit: null,
      size: null,
      height: '',
      heightGroup: ''
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
      event_path: this.props.event_path,
      edit: this.props.edit,
      initialDress: this.props.initialDress && this.props.initialDress.event_dress
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
