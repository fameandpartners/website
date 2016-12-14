var DesktopCustomizations = React.createClass({
  propTypes: {
    currentCustomization: React.PropTypes.string,
    selectedOptions: React.PropTypes.object,
    changeCurrentCustomizationCallback: React.PropTypes.func,
    selectCallback: React.PropTypes.func,
    startOverCallback: React.PropTypes.func
  },

  render: function(){
    var customizationMenuProps = {
      selectedOptions: this.props.selectedOptions,
      currentCustomization: this.props.currentCustomization,
      changeCurrentCustomizationCallback: this.props.changeCurrentCustomizationCallback,
      selectCallback: this.props.selectCallback,
      startOverCallback: this.props.startOverCallback,
      dresses: [1,3,4,5,65,6]
    };

    return(
      <div className="customization-experience--desktop hidden-xs">
        <div className="customization-panel col-sm-6">
          <CustomizationsMenu {...customizationMenuProps} />
        </div>
        <div className="dress-preview col-sm-6">
          <div className="controls">
          </div>
        </div>
        <div className="footer">
          <div className="favorites col-md-6">
            <img src="/assets/wedding-atelier/heart.svg"/>
            <span> 3</span>
          </div>

          <div className="results col-md-2 col-lg-3">
            <div className="view-customizations">
              <span className="left-result">
                <a href="#">View customizations</a>
              </span>
              <span className="right-result">
                $16
              </span>
            </div>

            <div className="sub-total">
              <span className="left-result">
                Sub-Total
              </span>
              <span className="right-result">
                $320
              </span>
            </div>
          </div>

          <div className="actions col-md-4 col-lg-3">
            <button className="btn-transparent">
               save this dress
            </button>
            <button className="btn-black">
               add to cart
            </button>
          </div>
        </div>
      </div>

    )
  }
})
