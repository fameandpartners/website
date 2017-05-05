var CustomizationSelectorMobile = React.createClass({
  propTypes: {
    type: React.PropTypes.string,
    options: React.PropTypes.array,
    selectedOption: React.PropTypes.object,
    keyword: React.PropTypes.string,
    title: React.PropTypes.string,
    description: React.PropTypes.string,
    selectCallback: React.PropTypes.func.isRequired,
    selectOptionCallback: React.PropTypes.func.isRequired,
    currentCustomization: React.PropTypes.string,
    selectedOptions: React.PropTypes.object,
    clickedOptions: React.PropTypes.object
  },

  isOptionDisabled: function(option){
    if(this.props.type === 'silhouette'){ return false; }
    var customizations = this.props.selectedOptions;
    var silhouette = customizations.silhouette ? customizations.silhouette.sku : 'FP2212';
    var fit = customizations.fit ? customizations.fit.name : 'F0';
    var style = customizations.style ? customizations.style.name : 'S0';
    var length = customizations.length ? customizations.length.name : 'AK';
    return CombinationsMap.isDisabled(this.props.type, option, silhouette, fit, style, length);
  },

  render: function () {
    var itemProps = {
      type: this.props.type,
      selectedOption: this.props.selectedOption,
      selectedOptions: this.props.selectedOptions,
      selectCallback: this.props.selectCallback,
      clickCustomizationCallback: this.props.selectOptionCallback,
      clickedOptions: this.props.clickedOptions
    }, options = [];

    this.props.options.forEach(function(option, index) {
      itemProps.option = $.extend({}, option);
      itemProps.mobile = true;
      if(!this.isOptionDisabled(itemProps.option)){
        options.push(<CustomizationItem key={index} {...itemProps} />);
      }
    }.bind(this));

    var containerClasses = classNames({
      'customizations-selector-mobile': true,
      'active': this.props.currentCustomization === this.props.type
    });

    var lenghtGuideModalLauncherComp = itemProps.type === "length" ? <LenghtGuideModalLauncher /> : '';

    if(options.length == 0){
      options = <p className="no-customizations">No customization options are available for this combination</p>
    }

    return (
      <div ref="container" className={containerClasses}>
        <div className="customizations-selector-mobile-title">
          <h1><em>{this.props.keyword}</em> {this.props.title}</h1>
          <p>{this.props.description} {lenghtGuideModalLauncherComp}</p>
        </div>
        <div className="customizations-selector-mobile-grid row">
          {options}
        </div>
      </div>
    );
  }

});
