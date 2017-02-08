var CustomizationItem = React.createClass({
  propTypes: {
    type: React.PropTypes.string,
    selectedOption: React.PropTypes.object,
    selectedOptions: React.PropTypes.object,
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
    if(this.props.selectedOptions){
      var images = new DressImageBuilder(this.props.selectedOptions)[this.props.type](this.props.option)
      return images.thumbnail.grey;
    }
  },

  renderItem: function(){
    var active = this.isOptionSelected(),
        clicked = this.isOptionClicked(),
        optionItemClasses = classNames({
          'customization-options-item': !this.props.mobile,
          'customizations-selector-mobile-options-item': this.props.mobile,
          active: active,
          clicked: clicked
        }),
        removeButton, customizationPrice;


    if(['silhouette', 'length'].indexOf(this.props.type) == -1){
      removeButton = <RemoveButton clickCallback={this.removeCustomization} active={active}/>;
    }

    if(['fit', 'style'].indexOf(this.props.type) > -1){
      customizationPrice = <span className="customization-price">{' + $' + parseFloat(this.props.option.price)}</span>
    }

    var presentation = (this.props.type === 'silhouette' ? 'The ' : '') + this.props.option.presentation;

    return (<div onClick={this.clickCustomizationHandle} className="col-xs-6 col-sm-6 col-md-6 col-lg-4">
        <div className={optionItemClasses}>
          {removeButton}
          <img src={this.imagePath()} />
          <p>{presentation}{customizationPrice}</p>
        </div>
      </div>)
  },

  render: function(){
    return(this.renderItem());
  }
})
