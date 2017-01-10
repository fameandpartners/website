var MobileCustomizations = React.createClass({
  propTypes: {
    changeCurrentCustomizationCallback: React.PropTypes.func,
    currentCustomization: React.PropTypes.string,
    customizations: React.PropTypes.object,
    selectCallback: React.PropTypes.func,
    selectedOptions: React.PropTypes.object,
    siteVersion: React.PropTypes.string,
    startOverCallback: React.PropTypes.func,
    subTotal: React.PropTypes.number,
    customizationsCost: React.PropTypes.number,
    eventSlug: React.PropTypes.string,
    currentUser: React.PropTypes.object
  },

  componentDidMount: function() {
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

  goToSlide: function(index) {
    $(this.refs.slickHook).slick('slickGoTo', index);
  },

  render: function() {
    var defaultProps = {
      customizations: this.props.customizations,
      currentCustomization: this.props.currentCustomization,
      selectedOptions: this.props.selectedOptions,
      changeCurrentCustomizationCallback: this.props.changeCurrentCustomizationCallback,
      selectCallback: this.props.selectCallback,
      goToSlide:  this.goToSlide
    };

    var customizationsReviewProps = $.extend(defaultProps, {
      siteVersion:  this.props.siteVersion,
      subTotal: this.props.subTotal,
      customizationsCost: this.props.customizationsCost,
      eventSlug: this.props.eventSlug,
      currentUser: this.props.currentUser
    });

    var customizationsMenuProps = $.extend(defaultProps, {
      startOverCallback: this.props.startOverCallback
    });

    var customizationsContainerMobileProps = $.extend(defaultProps, {
      startOverCallback: this.props.startOverCallback
    });

    return (
      <div className="customization-experience--mobile hidden-sm hidden-md hidden-lg">
        <div ref="slickHook" className="js-slick-hook">
          <CustomizationsReviewMobile {...customizationsReviewProps}/>
          <CustomizationsMenuMobile {...customizationsMenuProps}/>
          <CustomizationsContainerMobile {...customizationsContainerMobileProps}/>
        </div>
      </div>
    );
  }
});
