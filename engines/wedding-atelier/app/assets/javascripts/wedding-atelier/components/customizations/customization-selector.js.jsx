var CustomizationSelector = React.createClass({
  propTypes: {
    type: React.PropTypes.string,
    options: React.PropTypes.array,
    selectedOption: React.PropTypes.object,
    keyword: React.PropTypes.string,
    title: React.PropTypes.string,
    description: React.PropTypes.string,
    selectCallback: React.PropTypes.func.isRequired,
    currentCustomization: React.PropTypes.string,
    showContainers: React.PropTypes.object,
    selectedOptions: React.PropTypes.object
  },

  isOptionDisabled: function(option){
    if(this.props.type === 'silhouette'){ return false; }
    var customizations = this.props.selectedOptions;
    var optionsKeys = {
      silhouette: customizations.silhouette ? customizations.silhouette.sku : 'FP2212',
      fit: customizations.fit ? customizations.fit.name : 'F0',
      style: customizations.style ? customizations.style.name : 'S0',
      length: customizations.length ? customizations.length.name : 'AK'
    }

    if(customizations[this.props.type]){
      optionsKeys[this.props.type] = option.name;
    }

    return CombinationsMap.isDisabled(optionsKeys, option, this.props.type);
  },

  render: function() {
    var itemProps = {
      type: this.props.type,
      selectedOption: this.props.selectedOption,
      selectCallback: this.props.selectCallback
    }

    var options = this.props.options.map(function(option, index) {
      itemProps.option = $.extend({}, option);
      if(!this.isOptionDisabled(itemProps.option)){
        return(<CustomizationItem key={index} {...itemProps} />);
      }

    }.bind(this));

    var customizationSelectorClasses = classNames({
      'customization-selector': true,
      'animated': true,
      'slideInLeft': this.props.showContainers.showSelector,
      'active': this.props.currentCustomization === this.props.type
    });

    return (
      <div ref="container" className={customizationSelectorClasses}>
        <div className="customization">
          <div className="customization-title">
            <h1><em>{this.props.keyword}</em> {this.props.title}</h1>
            <p className="description">{this.props.description}</p>
          </div>
          <div className="customization-options-grid row">
            {options}
          </div>
        </div>
      </div>
    );
  }
});
