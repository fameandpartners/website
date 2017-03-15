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
      color: null,
      fabric: null,
      fit: null,
      length: null,
      silhouette: null,
      style: null
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
    this.close();
  },

  render: function() {
    var currentCustomization = this.props.currentCustomization,
        title = currentCustomization ? currentCustomization.split('-').join(' and ') : '';

    var selectedOptions = $.extend({}, this.props.selectedOptions);

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
          selectedOption={selectedOptions.silhouette}
          currentCustomization={this.props.currentCustomization}
          selectedOptions={selectedOptions}
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
          selectedOptions={selectedOptions}
          currentCustomization={this.props.currentCustomization}
          ref="fabric-color"/>
        <CustomizationSelectorMobile
          type="length"
          selectCallback={this.props.selectCallback}
          selectOptionCallback={this.selectOption}
          options={this.props.customizations.lengths}
          selectedOption={selectedOptions.length}
          currentCustomization={this.props.currentCustomization}
          selectedOptions={selectedOptions}
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
          selectedOption={selectedOptions.style}
          currentCustomization={this.props.currentCustomization}
          selectedOptions={selectedOptions}
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
          selectedOption={selectedOptions.fit}
          currentCustomization={this.props.currentCustomization}
          selectedOptions={selectedOptions}
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
