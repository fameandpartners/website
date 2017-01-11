var DesktopCustomizations = React.createClass({
  propTypes: {
    siteVersion: React.PropTypes.string,
    currentCustomization: React.PropTypes.string,
    selectedOptions: React.PropTypes.object,
    customizations: React.PropTypes.object,
    changeCurrentCustomizationCallback: React.PropTypes.func,
    selectCallback: React.PropTypes.func,
    startOverCallback: React.PropTypes.func,
    subTotal: React.PropTypes.number,
    customizationsCost: React.PropTypes.number,
    eventSlug: React.PropTypes.string
  },

  getInitialState: function () {
    return {
      showContainer: false,
      showSelector: false,
      showLateralMenu: false
    };
  },

  changeLateralMenuState: function (state) {
    this.setState({showLateralMenu: state});
  },

  changeContainerState: function (state) {
    this.setState({showContainer: state});
  },

  show: function(currentCustomization) {
    var el = $('.js-customizations-container');

    this.setState({
      showSelector: true,
      showContainer: true
    });

    el.one('transitionend', function() {
      this.changeLateralMenuState(true);
    }.bind(this));

    this.props.changeCurrentCustomizationCallback(currentCustomization);
  },

  close: function() {
    var el = $('.js-customizations-lateral-menu');
    el.one('transitionend', function() {
      this.changeContainerState(false);
    }.bind(this));
    this.setState({showLateralMenu: false});
  },

  viewCustomizations: function(){
    $('.modal-customizations').modal();
  },

  render: function() {
    var defaultProps = {
      selectedOptions:                    this.props.selectedOptions,
      currentCustomization:               this.props.currentCustomization,
      changeCurrentCustomizationCallback: this.props.changeCurrentCustomizationCallback,
      selectCallback:                     this.props.selectCallback,
      showContainers:                     this.state
    };

    var customizationMenuProps = $.extend(defaultProps, {
      startOverCallback: this.props.startOverCallback,
      siteVersion: this.props.siteVersion,
      changeContainerStateCallback: this.changeContainerState,
      showCallback: this.show
    });

    var customizationsContainerProps = $.extend(defaultProps, {
      customizations: this.props.customizations,
      selectedOptions: this.props.selectedOptions,
      showLateralMenuCallback: this.changeLateralMenuState,
      closeCallback: this.close
    });

    return (
      <div className="customization-experience--desktop hidden-xs">
        <CustomizationsHeader silhouette={this.props.selectedOptions.silhouette}/>
        <div className="customization-panel col-sm-6">
          <CustomizationsMenu {...customizationMenuProps} />
          <CustomizationsContainer {...customizationsContainerProps} />
        </div>
        <div className="customization-panel col-sm-6">
          <DressPreview selectedOptions={this.props.selectedOptions} />
        </div>
        <div className="footer">
          <div className="favorites col-md-6">
            <img src="/assets/wedding-atelier/heart.svg"/>
            <span> 3</span>
          </div>

          <div className="results col-md-2 col-lg-3">
            <div className="view-customizations">
              <span className="left-result">
                <a href="#" onClick={this.viewCustomizations}>View customizations</a>
              </span>
              <span className="right-result">
                ${this.props.customizationsCost}
              </span>
            </div>

            <div className="sub-total">
              <span className="left-result">
                Sub-Total
              </span>
              <span className="right-result">
                ${this.props.subTotal}
              </span>
            </div>
          </div>

          <div className="actions col-md-4 col-lg-3">
            <SaveDressButton
              eventSlug={this.props.eventSlug}
              selectedOptions={this.props.selectedOptions}
              mobile={false}
              />
            <AddToCartButton customizations={this.props.selectedOptions} />
          </div>
        </div>
      </div>
    );
  }
});

var AddToCartButton = React.createClass({
  propTypes: {
    customizations: React.PropTypes.object
  },
  handleAddToCart: function () {
    customizations = this.props.customizations;
    size_id = customizations.size.id || customizations.size.user_profile.dress_size_id;
    var attrs = {
      size_id: size_id,
      color_id: customizations.colour.id,
      variant_id: customizations.silhouette.variant_id,
      height: customizations.height,
      length_id: customizations.length.id,
      fabric_id: customizations.fabric.id,
      customizations_ids: [customizations.fit.id, customizations.style.id]
      //making_options_ids: ""
    }
    shoppingCart = new helpers.ShoppingCart({});
    shoppingCart.addProduct(attrs);
  },
  render: function(){
    return(
        <button className="btn-black" onClick={this.handleAddToCart}> add to cart </button>
    )
  }
})
