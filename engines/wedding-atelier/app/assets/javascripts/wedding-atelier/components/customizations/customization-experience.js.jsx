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

  componentWillMount: function() {
    $.get(this.props.customizationsUrl, function(data) {
      var selectedOptions = {
        silhouette: data.customization.silhouettes[0]
      };
      var customizations = data.customization;
      customizations.fits = selectedOptions.silhouette.fits;
      customizations.styles = selectedOptions.silhouette.styles;

      var newState = {
        selectedOptions: selectedOptions,
        customizations: customizations
      };

      this.setState(newState);
    }.bind(this));
  },

  changeCurrentCustomizationCallback: function(currentCustomization) {
    this.setState({currentCustomization: currentCustomization});
  },

  selectCallback: function(customization, value) {
    var newState = $.extend(this.state, {});
    newState.selectedOptions[customization] = value;

    if(customization === 'silhouette' && value) {
      newState.customizations.styles = value.styles;
      newState.customizations.fits = value.fits;
    }
    if(customization === 'size' && value){
      newState.customizations.size = value;
      newState.customizations.height = value.fits;
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

    var props = {
      selectedOptions:                    this.state.selectedOptions,
      currentCustomization:               this.state.currentCustomization,
      customizations:                     this.state.customizations,
      changeCurrentCustomizationCallback: this.changeCurrentCustomizationCallback,
      selectCallback:                     this.selectCallback,
      startOverCallback:                  this.startOverCallback,
      siteVersion: 						            this.props.siteVersion
    };

    return (
      <div className="customization-experience container-fluid">
        <MobileCustomizations {...props} />
        <DesktopCustomizations {...props} />
      </div>
    );
  }
});
