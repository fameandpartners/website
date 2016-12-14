var MobileCustomizations = React.createClass({
  propTypes: {
    currentCustomization: React.PropTypes.string,
    selectedOptions: React.PropTypes.object,
    changeCurrentCustomizationCallback: React.PropTypes.func,
    selectCallback: React.PropTypes.func,
    startOverCallback: React.PropTypes.func
  },

  render: function() {
    var customizationMenuProps = {
      selectedOptions: this.props.selectedOptions,
      currentCustomization: this.props.currentCustomization,
      changeCurrentCustomizationCallback: this.props.changeCurrentCustomizationCallback,
      selectCallback: this.props.selectCallback,
      startOverCallback: this.props.startOverCallback,
      dresses: [1,3,4,5,65,6]
    };

    return(
      <div className="customization-experience--mobile hidden-sm hidden-md hidden-lg">
        <h1>You are designing #{"the Wonderland"}</h1>
        <div className="dress-preview"></div>
        <div className="customization-panel hidden">
          <CustomizationsMenu {...customizationMenuProps}/>
        </div>
        <button className="btn-transparent btn-block js-customize-dress">
          customize dress
        </button>
        <button className="btn-transparent btn-block">
          select size
        </button>

        <div className="results">
          <div className="view-customizations">
            <span className="left-result">
              <a href="#">View customizations</a>
            </span>
            <span className="right-result">$16</span>
          </div>
          <div className="sub-total">
            <span className="left-result">Sub-total</span>
            <span className="right-result">$320</span>
          </div>
        </div>

        <p className="estimated-delivery">
          Estimated delivery 7 days
        </p>
        <div className="actions">
          <button className="btn-gray">save to board</button>
          <button className="btn-black">add to cart</button>
        </div>
      </div>
    )
  }
})
