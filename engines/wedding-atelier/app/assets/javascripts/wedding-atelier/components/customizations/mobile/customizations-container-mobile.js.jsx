var CustomizationsContainerMobile = React.createClass({
  propTypes: {
    changeCurrentCustomizationCallback: React.PropTypes.func,
    currentCustomization: React.PropTypes.string,
    customizations: React.PropTypes.object,
    selectCallback: React.PropTypes.func,
    selectedOptions: React.PropTypes.object,
    siteVersion: React.PropTypes.string,
    startOverCallback: React.PropTypes.func,
    goToSlide: React.PropTypes.func,
    currentUser: React.PropTypes.object
  },

  getInitialState: function () {
    return {
      silhouette: null,
      fabric: null,
      color: null,
      length: null,
      style: null,
      fit: null
    };
  },

  close: function() {
    this.setState({currentValue: null});
    this.props.goToSlide(1);
  },

  selectOption: function (type, option) {
    var newState = {};
    newState[type] = option;
    this.setState(newState);
  },

  applyChanges: function () {
    for(var property in this.state) {
      if(this.state.hasOwnProperty(property) && this.state[property] != null) {
        this.props.selectCallback(property, this.state[property]);
      }
    }
  },

  render: function() {
    var currentCustomization = this.props.currentCustomization,
        title = currentCustomization ? currentCustomization.split('-').join(' and ') : '';

    return (
      <div ref="customizationsContainer" className="customizations-container-mobile">
        <div className="customizations-container-mobile-header">
          <i className={"icon icon-" + currentCustomization}></i>
          <p className="selector-name text-left">{title}</p>
          <div className="selector-close" onClick={this.close}></div>
        </div>
        <CustomizationSelectorMobile
          type="silhouette"
          selectCallback={this.props.selectCallback}
          selectOptionCallback={this.selectOption}
          options={this.props.customizations.silhouettes}
          selectedOption={this.props.selectedOptions.silhouette}
          currentCustomization={this.props.currentCustomization}
          selectedOptions={this.props.selectedOptions}
          clickedOptions={this.state}
          ref="silhouette"
          keyword="Choose"
          title="your perfect shape."
          description="The silhouette is the foundation of your dress."/>
        <FabricAndColorSelectorMobile
          colors={this.props.customizations.colors}
          fabrics={this.props.customizations.fabrics}
          selectOptionCallback={this.selectOption}
          selectCallback={this.props.selectCallback}
          selectedOptions={this.props.selectedOptions}
          currentCustomization={this.props.currentCustomization}
          ref="fabric-color"/>
        <CustomizationSelectorMobile
          type="length"
          selectCallback={this.props.selectCallback}
          selectOptionCallback={this.selectOption}
          options={this.props.customizations.lengths}
          selectedOption={this.props.selectedOptions.length}
          currentCustomization={this.props.currentCustomization}
          selectedOptions={this.props.selectedOptions}
          clickedOptions={this.state}
          ref="length"
          keyword="Choose"
          title="your length."
          description="One skirt does not fit all. Find the length that suits you best."/>
        <CustomizationSelectorMobile
          type="style"
          selectCallback={this.props.selectCallback}
          selectOptionCallback={this.selectOption}
          options={this.props.customizations.styles}
          selectedOption={this.props.selectedOptions.style}
          currentCustomization={this.props.currentCustomization}
          selectedOptions={this.props.selectedOptions}
          clickedOptions={this.state}
          ref="style"
          keyword="Design"
          title="the details."
          description="Close your eyes and picture your dream dress. Now, create it."/>
        <CustomizationSelectorMobile
          type="fit"
          selectCallback={this.props.selectCallback}
          selectOptionCallback={this.selectOption}
          options={this.props.customizations.fits}
          selectedOption={this.props.selectedOptions.fit}
          currentCustomization={this.props.currentCustomization}
          selectedOptions={this.props.selectedOptions}
          clickedOptions={this.state}
          ref="fit"
          keyword="Finesse"
          title="the way it fits."
          description="Almost done: change the neckline, backline, straps, or skirt."/>

        <div className="customizations-selector-mobile-actions-double">
          <button className="btn-gray" onClick={this.close}>cancel</button>
          <button className="btn-black" onClick={this.applyChanges}>select</button>
        </div>
      </div>
    );
  }
});
