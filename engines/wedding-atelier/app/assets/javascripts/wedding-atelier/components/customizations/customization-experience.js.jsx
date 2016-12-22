var CustomizationExperience = React.createClass({
  propTypes: {
    customizationsUrl: React.PropTypes.string,
    siteVersion: React.PropTypes.string
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
      var newState = $.extend({}, this.state),
      silhouette = data.customization.silhouettes[0];
      newState.selectedOptions.silhouette = silhouette
      newState.customizations = data.customization;
      newState.customizations.fits = silhouette.fits;
      newState.customizations.styles = silhouette.styles;
      newState.subTotal = parseInt(silhouette.price);
      newState.customizationsCost = this.customizationsCost();
      this.setState(newState);
    }.bind(this));
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
      height: null
    }});
  },

  render: function() {

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
      customizationsCost: this.state.customizationsCost
    };

    return (
      <div className="customization-experience container-fluid">
        <MobileCustomizations {...props} />
        <DesktopCustomizations {...props} />
      </div>
    );
  }
});
