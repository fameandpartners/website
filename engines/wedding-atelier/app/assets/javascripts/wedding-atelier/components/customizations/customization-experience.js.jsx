var CustomizationExperience = React.createClass({
  propTypes: {
    customizationsUrl: React.PropTypes.string,
    siteVersion: React.PropTypes.string
  },

  getInitialState: function() {
    return {
      currentCustomization: null,
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

  componentDidMount: function(){
    $.get(this.props.customizationsUrl, function(data){
      var newState = $.extend({}, this.state),
      silhouette = data.customization.silhouettes[0];
      newState.selectedOptions.silhouette = silhouette
      newState.customizations = data.customization;
      newState.customizations.fits = silhouette.fits;
      newState.customizations.styles = silhouette.styles;
      this.setState(newState);
    }.bind(this))
  },

  changeCurrentCustomizationCallback: function(currentCustomization){
    this.setState({ currentCustomization: currentCustomization });
  },

  selectCallback: function(customization, value){
    var newState = $.extend({}, this.state);
    newState.selectedOptions[customization] = value;

    if(customization == 'silhouette' && value){
      newState.customizations.styles = value.styles;
      newState.customizations.fits = value.fits;
    }
    this.setState(newState);
  },

  startOverCallback: function () {
    var newState = $.exent({}, this.state);
    newState.selectedOptions = {
      silhouette: null,
      fabric: null,
      colour: null,
      length: null,
      style: null,
      fit: null,
      size: null,
      height: null
    };
    this.setState(newState);
  },


  render: function(){

    var props = {
      selectedOptions: this.state.selectedOptions,
      currentCustomization: this.state.currentCustomization,
      customizations: this.state.customizations,
      changeCurrentCustomizationCallback: this.changeCurrentCustomizationCallback,
      selectCallback: this.selectCallback,
      startOverCallback: this.startOverCallback,
      siteVersion: this.props.siteVersion
    };

    return(
      <div className="customization-experience container-fluid">
        <MobileCustomizations {...props} />
        <DesktopCustomizations {...props} />
      </div>
    );
  }
})
