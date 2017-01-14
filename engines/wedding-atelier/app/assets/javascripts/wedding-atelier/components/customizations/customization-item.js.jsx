var CustomizationItem = React.createClass({
  propTypes: {
    type: React.PropTypes.string,
    selectedOption: React.PropTypes.object,
    option: React.PropTypes.object,
    selectCallback: React.PropTypes.func.isRequired,
    disabled: React.PropTypes.bool
  },

  selectCustomization: function(){
    this.props.selectCallback(this.props.type, this.props.option);
  },

  removeCustomization: function(e){
    e.stopPropagation();
    this.props.selectCallback(this.props.type, null);
  },

  isOptionSelected: function(){
    var selectedOption = this.props.selectedOption;
    return selectedOption && selectedOption.id == this.props.option.id;
  },

  render: function(){
    var active = this.isOptionSelected(),
        optionItemClasses = classNames({
          'customization-options-item': true,
          active: active,
          disabled: this.props.disabled
        });

    return(
      <div onClick={this.selectCustomization} className="col-sm-6 col-md-6 col-lg-4">
        <div className={optionItemClasses}>
          <RemoveButton clickCallback={this.removeCustomization} active={active}/>
          <img src={this.props.option.image} />
          <p>{this.props.option.presentation}</p>
        </div>
      </div>
    );
  }
})
