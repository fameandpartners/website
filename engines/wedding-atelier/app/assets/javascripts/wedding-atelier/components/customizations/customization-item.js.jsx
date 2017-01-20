var CustomizationItem = React.createClass({
  propTypes: {
    type: React.PropTypes.string,
    selectedOption: React.PropTypes.object,
    selectedOptions: React.PropTypes.array,
    option: React.PropTypes.object,
    selectCallback: React.PropTypes.func.isRequired,
    clickCustomizationCallback: React.PropTypes.func.isRequired,
    mobile: React.PropTypes.bool,
    clickedOptions: React.PropTypes.object
  },

  removeCustomization: function(e){
    e.stopPropagation();
    this.props.selectCallback(this.props.type, null);
  },

  clickCustomizationHandle: function(){
    this.props.clickCustomizationCallback(this.props.type, this.props.option)
  },

  isOptionClicked: function(){
    var clickedOption = this.props.clickedOptions[this.props.type];
    return clickedOption && clickedOption.id == this.props.option.id;
  },

  isOptionSelected: function(){
    var selectedOption = this.props.selectedOption;
    return selectedOption && selectedOption.id == this.props.option.id;
  },

  imagePath: function(){
    var basePath = ''
  },

  render: function(){
    console.log(this.props.type)
    var active = this.isOptionSelected(),
        clicked = this.isOptionClicked(),
        optionItemClasses = classNames({
          'customization-options-item': !this.props.mobile,
          'customizations-selector-mobile-options-item': this.props.mobile,
          active: active,
          clicked: clicked
        });

    return(
      <div onClick={this.clickCustomizationHandle} className="col-xs-6 col-sm-6 col-md-6 col-lg-4">
        <div className={optionItemClasses}>
          <RemoveButton clickCallback={this.removeCustomization} active={active}/>
          <img src={this.imagePath()} />
          <p>{this.props.option.presentation}</p>
        </div>
      </div>
    );
  }
})
