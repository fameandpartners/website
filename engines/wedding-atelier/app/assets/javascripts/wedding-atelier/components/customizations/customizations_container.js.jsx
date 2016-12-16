var CustomizationsContainer = React.createClass({
  propTypes: {
    selectedOptions:                    React.PropTypes.object,
    customizations:                     React.PropTypes.object,
    currentCustomization:               React.PropTypes.string,
    changeCurrentCustomizationCallback: React.PropTypes.func,
    assistants:                         React.PropTypes.array,
    selectCallback:                     React.PropTypes.func,
    goToSlideCallback:                  React.PropTypes.func
  },

  componentDidUpdate: function(){
    var el = $(ReactDOM.findDOMNode(this.refs.customizationsContainer));

    el.find('.customization-selector').hide();
    $(ReactDOM.findDOMNode(this.refs[this.props.currentCustomization])).show();
  },

  close: function(ref){
    var el = $('.js-customizations-lateral-menu');
    el.one('transitionend', function() {
      $('.js-customizations-container').removeClass('animate');
    }.bind(this));
    el.removeClass('animate');
  },

  render: function(){
    var currentCustomization = this.props.currentCustomization,
        title = currentCustomization ? currentCustomization.split('-').join(' and ') : '';

    return (
      <div ref="customizationsContainer" className="js-customizations-container customizations-container">
        <div className="selector-header">
          <i className={"icon icon-" + currentCustomization}></i>
          <div className="selector-name text-left">{title}</div>
          <div className="selector-close" onClick={this.close}></div>
        </div>
        <div className="selector-body">
          <CustomizationSelector
            type="silhouette"
            selectCallback={this.props.selectCallback}
            options={this.props.customizations.silhouettes}
            selectedOption={this.props.selectedOptions.silhouette}
            ref="silhouette"
            keyword="Choose"
            title="your perfect shape"
            description="Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."/>
          <FabricAndColourSelector
            colours={this.props.customizations.colours}
            fabrics={this.props.customizations.fabrics}
            selectCallback={this.props.selectCallback}
            selectedOption={this.props.selectedOptions.colour}
            ref="fabric-colour"/>
          <CustomizationSelector
            type="length"
            selectCallback={this.props.selectCallback}
            options={this.props.customizations.lengths}
            selectedOption={this.props.selectedOptions.length}
            ref="length"
            keyword="Choose"
            title="your length."
            description="Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."/>
          <CustomizationSelector
            type="style"
            selectCallback={this.props.selectCallback}
            options={this.props.customizations.styles}
            selectedOption={this.props.selectedOptions.style}
            ref="style"
            keyword="Add"
            title="on extra trimmings."
            description="Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."/>
          <CustomizationSelector
            type="fit"
            selectCallback={this.props.selectCallback}
            options={this.props.customizations.fits}
            selectedOption={this.props.selectedOptions.fit}
            ref="fit"
            keyword="Finesse"
            title="the way it fits."
            description="Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."/>
          <SizeSelector
            sizes={this.props.customizations.sizes}
            assistants={this.props.customizations.assistants}
            heights={this.props.customizations.heights}
            siteVersion={this.props.siteVersion}
            selectCallback={this.props.selectCallback}
            type={this.props.type}
            ref="size"/>
        </div>
      </div>
    );
  }
});
