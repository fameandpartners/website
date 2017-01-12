var CustomizationsContainer = React.createClass({
  propTypes: {
    selectedOptions: React.PropTypes.object,
    customizations: React.PropTypes.object,
    currentCustomization: React.PropTypes.string,
    siteVersion: React.PropTypes.string,
    changeCurrentCustomizationCallback: React.PropTypes.func,
    assistants: React.PropTypes.array,
    selectCallback: React.PropTypes.func,
    goToSlideCallback: React.PropTypes.func,
    showContainers: React.PropTypes.object,
    showLateralMenuCallback: React.PropTypes.func,
    closeCallback: React.PropTypes.func,
    currentUser: React.PropTypes.object
  },

  render: function() {
    var currentCustomization = this.props.currentCustomization,
        title = currentCustomization ? currentCustomization.split('-').join(' and ') : '';

    var customizationsContainerClasses = classNames({
      'js-customizations-container': true,
      'customizations-container': true,
      'animate': this.props.showContainers.showContainer
    });

    return (
      <div ref="customizationsContainer" className={customizationsContainerClasses} onTransitionEnd={this.props.showLateralMenuCallback.bind(null, true)}>
        <div className="selector-header">
          <i className={"icon icon-" + currentCustomization}></i>
          <div className="selector-name text-left">{title}</div>
          <div className="selector-close" onClick={this.props.closeCallback}></div>
        </div>
        <div className="selector-body">
          <CustomizationSelector
            type="silhouette"
            selectCallback={this.props.selectCallback}
            showLateralMenuCallback={this.props.showLateralMenuCallback}
            options={this.props.customizations.silhouettes}
            selectedOption={this.props.selectedOptions.silhouette}
            currentCustomization={this.props.currentCustomization}
            keyword="Choose"
            title="your perfect shape."
            description="Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
            showContainers={this.props.showContainers}/>
          <FabricAndColourSelector
            colours={this.props.customizations.colours}
            fabrics={this.props.customizations.fabrics}
            selectCallback={this.props.selectCallback}
            showLateralMenuCallback={this.props.showLateralMenuCallback}
            currentCustomization={this.props.currentCustomization}
            showContainers={this.props.showContainers}/>
          <CustomizationSelector
            type="length"
            selectCallback={this.props.selectCallback}
            showLateralMenuCallback={this.props.showLateralMenuCallback}
            options={this.props.customizations.lengths}
            selectedOption={this.props.selectedOptions.length}
            currentCustomization={this.props.currentCustomization}
            keyword="Choose"
            title="your length."
            description="Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
            showContainers={this.props.showContainers}/>
          <CustomizationSelector
            type="style"
            selectCallback={this.props.selectCallback}
            showLateralMenuCallback={this.props.showLateralMenuCallback}
            options={this.props.customizations.styles}
            selectedOption={this.props.selectedOptions.style}
            currentCustomization={this.props.currentCustomization}
            keyword="Design"
            title="the details."
            description="Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
            showContainers={this.props.showContainers}/>
          <CustomizationSelector
            type="fit"
            selectCallback={this.props.selectCallback}
            showLateralMenuCallback={this.props.showLateralMenuCallback}
            options={this.props.customizations.fits}
            selectedOption={this.props.selectedOptions.fit}
            currentCustomization={this.props.currentCustomization}
            keyword="Tailor"
            title="to your body."
            description="Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
            showContainers={this.props.showContainers}/>
          <SizeSelector
            sizes={this.props.customizations.sizes}
            assistants={this.props.customizations.assistants}
            heights={this.props.customizations.heights}
            siteVersion={this.props.siteVersion}
            selectCallback={this.props.selectCallback}
            showLateralMenuCallback={this.props.showLateralMenuCallback}
            currentCustomization={this.props.currentCustomization}
            currentUser={this.props.currentUser}
            showContainers={this.props.showContainers}/>
        </div>
      </div>
    );
  }
});
