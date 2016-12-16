var MobileCustomizations = React.createClass({
  propTypes: {
    siteVersion: React.PropTypes.string,
    currentCustomization: React.PropTypes.string,
    selectedOptions: React.PropTypes.object,
    customizations: React.PropTypes.object,
    changeCurrentCustomizationCallback: React.PropTypes.func,
    selectCallback: React.PropTypes.func,
    startOverCallback: React.PropTypes.func
  },

  componentDidMount: function(){
    $(this.refs.slickHook).slick({
      arrows: false,
      swipe: false,
      slidesToShow: 1,
      speed: 300,
      adaptiveHeight: true,
      dots: false,
      infinite: false
    });
  },

  goToSlide: function(index){
      $(this.refs.slickHook).slick('slickGoTo', index)
  },

  render: function() {
    var defaultProps = {
      selectedOptions: this.props.selectedOptions,
      currentCustomization: this.props.currentCustomization,
      changeCurrentCustomizationCallback: this.props.changeCurrentCustomizationCallback,
      selectCallback: this.props.selectCallback
    };

    var customizationMenuProps = $.extend(defaultProps, {
      startOverCallback: this.props.startOverCallback,
      siteVersion: this.props.siteVersion
    })

    var customizationsContainerProps = $.extend(defaultProps, {
      type: 'mobile',
      goToSlideCallback: this.goToSlide,
      customizations: this.props.customizations,
      selectedOptions: this.props.selectedOptions
    })

    return(
      <div className="customization-experience--mobile hidden-sm hidden-md hidden-lg">
        <div ref="slickHook" className="js-slick-hook">
          <div className="customizations-mobile-review">
            <NavBar/>
            <h1>You are designing #{"the Wonderland"}</h1>
            <DressPreview />
            <button className="btn-transparent btn-block js-customize-dress" onClick={this.goToSlide.bind(this, 1)}>
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
          <div className="customization-panel customizations-mobile-menu">
            <DressPreview />
            <CustomizationsMenu {...customizationMenuProps}/>
          </div>
          <div className="customizations-options-mobile">
          <CustomizationsContainer {...customizationsContainerProps} />
        </div>
        </div>
      </div>
    )
  }
})
