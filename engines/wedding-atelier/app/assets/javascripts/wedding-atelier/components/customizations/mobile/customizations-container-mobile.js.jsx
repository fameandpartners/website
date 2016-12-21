var CustomizationsContainerMobile = React.createClass({
  propTypes: {
    changeCurrentCustomizationCallback:     React.PropTypes.func,
    currentCustomization:                   React.PropTypes.string,
    customizations:                         React.PropTypes.object,
    selectCallback:                         React.PropTypes.func,
    selectedOptions:                        React.PropTypes.object,
    siteVersion:                            React.PropTypes.string,
    startOverCallback:                      React.PropTypes.func,
    goToSlide:                              React.PropTypes.func
  },

  getInitialState: function () {
    return {
      silhouette: null,
      fabric: null,
      colour: null,
      length: null,
      style: null,
      fit: null
    };
  },

  componentDidUpdate: function() {
    var el = $(ReactDOM.findDOMNode(this.refs.customizationsContainer));
    el.find('.customizations-selector-mobile').hide();
    $(ReactDOM.findDOMNode(this.refs[this.props.currentCustomization])).show();
  },

  close: function() {
    var newState = {};
    newState.currentValue = null;
    this.setState(newState);
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
          ref="silhouette"
          keyword="Create"
          title="it how you want"
          description="Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."/>
        <FabricAndColourSelectorMobile
          colours={this.props.customizations.colours}
          fabrics={this.props.customizations.fabrics}
          selectOptionCallback={this.selectOption}
          selectCallback={this.props.selectCallback}
          selectedOption={this.props.selectedOptions.colour}
          ref="fabric-colour"/>
        <CustomizationSelectorMobile
          type="length"
          selectCallback={this.props.selectCallback}
          selectOptionCallback={this.selectOption}
          options={this.props.customizations.lengths}
          selectedOption={this.props.selectedOptions.length}
          ref="length"
          keyword="Choose"
          title="your length."
          description="Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."/>
        <CustomizationSelectorMobile
          type="style"
          selectCallback={this.props.selectCallback}
          selectOptionCallback={this.selectOption}
          options={this.props.customizations.styles}
          selectedOption={this.props.selectedOptions.style}
          ref="style"
          keyword="Add"
          title="on extra trimmings."
          description="Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."/>
        <CustomizationSelectorMobile
          type="fit"
          selectCallback={this.props.selectCallback}
          selectOptionCallback={this.selectOption}
          options={this.props.customizations.fits}
          selectedOption={this.props.selectedOptions.fit}
          ref="fit"
          keyword="Finesse"
          title="the way it fits."
          description="Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."/>
        <div className="customizations-selector-mobile-actions-double">
          <button className="btn-gray" onClick={this.close}>cancel</button>
          <button className="btn-black" onClick={this.applyChanges}>apply</button>
        </div>
      </div>
    );
  }
});
