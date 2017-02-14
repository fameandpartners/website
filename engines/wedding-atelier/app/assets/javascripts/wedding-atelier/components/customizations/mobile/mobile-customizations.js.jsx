var MobileCustomizations = React.createClass({
  propTypes: {
    changeCurrentCustomizationCallback: React.PropTypes.func,
    currentCustomization: React.PropTypes.string,
    currentUser: React.PropTypes.object,
    customizations: React.PropTypes.object,
    customizationsCost: React.PropTypes.number,
    edit: React.PropTypes.bool,
    event_name: React.PropTypes.string,
    event_path: React.PropTypes.string,
    eventId: React.PropTypes.number,
    initialDress: React.PropTypes.object,
    savedDressCallback: React.PropTypes.func.isRequired,
    selectCallback: React.PropTypes.func,
    selectedOptions: React.PropTypes.object,
    siteVersion: React.PropTypes.string,
    startOverCallback: React.PropTypes.func,
    subTotal: React.PropTypes.number
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
      changeCurrentCustomizationCallback: this.props.changeCurrentCustomizationCallback,
      currentCustomization: this.props.currentCustomization,
      customizations: this.props.customizations,
      goToSlide:  this.goToSlide,
      selectCallback: this.props.selectCallback,
      selectedOptions: this.props.selectedOptions
    };

    var customizationsReviewProps = $.extend(defaultProps, {
      currentUser: this.props.currentUser,
      customizationsCost: this.props.customizationsCost,
      edit: this.props.edit,
      event_name: this.props.event_name,
      event_path: this.props.event_path,
      eventId: this.props.eventId,
      initialDress: this.props.initialDress,
      savedDressCallback: this.props.savedDressCallback,
      siteVersion:  this.props.siteVersion,
      subTotal: this.props.subTotal
    });

    var customizationsMenuProps = $.extend(defaultProps, {
      startOverCallback: this.props.startOverCallback
    });

    var customizationsContainerMobileProps = $.extend(defaultProps, {
      selectedOptions: this.props.selectedOptions,
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
