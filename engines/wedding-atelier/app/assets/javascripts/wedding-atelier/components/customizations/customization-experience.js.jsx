var CustomizationExperience = React.createClass({
  propTypes: {
    customizationsUrl:  React.PropTypes.string,
    siteVersion:        React.PropTypes.string
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
      var _state = this.state,
      silhouette = data.customization.silhouettes[0];
      _state.selectedOptions.silhouette = silhouette;
      _state.customizations = data.customization;
      _state.customizations.fits = silhouette.fits;
      _state.customizations.styles = silhouette.styles;
      this.setState(_state);
    }.bind(this));
  },

  changeCurrentCustomizationCallback: function(currentCustomization) {
    var _state = this.state;
    _state.currentCustomization = currentCustomization;
    this.setState(_state);
  },

  selectCallback: function(customization, value) {
    var _state = this.state;
    _state.selectedOptions[customization] = value;

    if(customization === 'silhouette' && value) {
      _state.customizations.styles = value.styles;
      _state.customizations.fits = value.fits;
    }
    if(customization === 'size' && value){
      _state.customizations.size = value;
      _state.customizations.height = value.fits;
    }
    this.setState(_state);
  },

  startOverCallback: function () {
    var _state = this.state;
    _state.selectedOptions = {
      silhouette: null,
      fabric: null,
      colour: null,
      length: null,
      style: null,
      fit: null,
      size: null,
      height: null
    };
    this.setState(_state);
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
