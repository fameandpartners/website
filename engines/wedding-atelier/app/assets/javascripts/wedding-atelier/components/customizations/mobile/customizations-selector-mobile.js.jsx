var CustomizationSelectorMobile = React.createClass({
  propTypes: {
    type: React.PropTypes.string,
    options: React.PropTypes.array,
    selectedOption: React.PropTypes.object,
    keyword: React.PropTypes.string,
    title: React.PropTypes.string,
    description: React.PropTypes.string,
    selectCallback: React.PropTypes.func.isRequired,
    selectOptionCallback: React.PropTypes.func.isRequired
  },

  isOptionSelected: function(option) {
    var selectedOption = this.props.selectedOption;
    return selectedOption && selectedOption.id == option.id;
  },

  removeCustomization: function(e) {
    e.stopPropagation();
    this.props.selectCallback(this.props.type, null);
  },

  render: function () {

    var options = this.props.options.map(function (option, index) {
      var optionClasses = classNames({
        'customizations-selector-mobile-options-item': true,
        active: this.isOptionSelected(option)
      });

      var customizationClass = 'customizations-selector-mobile-options-item';
      return (
        <div key={index} onClick={this.props.selectOptionCallback.bind(null, this.props.type, option)} className="col-xs-6">
          <div className={optionClasses}>
            <RemoveButton clickCallback={this.removeCustomization} active={this.isOptionSelected(option)}/>
            <img src={option.image} />
            <p>{option.name}</p>
          </div>
        </div>
      );

    }.bind(this));

    return (
      <div ref="container" className="customizations-selector-mobile">
        <div className="customizations-selector-mobile-title">
          <h1><em>{this.props.keyword}</em> {this.props.title}</h1>
          <p>{this.props.description}</p>
        </div>
        <div className="customizations-selector-mobile-grid row">
          {options}
        </div>
      </div>
    );
  }

});
