var MobileCustomizations = React.createClass({
  propTypes: {
    currentCustomization:               React.PropTypes.string,
    selectedOptions:                    React.PropTypes.object,
    customizations:                     React.PropTypes.object,
    changeCurrentCustomizationCallback: React.PropTypes.func,
    selectCallback:                     React.PropTypes.func,
    startOverCallback:                  React.PropTypes.func
  },

  componentDidMount: function() {
    $(this.refs.slickHook).slick({
      arrows: false,
      swipe: true,
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
      selectedOptions:                      this.props.selectedOptions,
      currentCustomization:                 this.props.currentCustomization,
      changeCurrentCustomizationCallback:   this.props.changeCurrentCustomizationCallback,
      selectCallback:                       this.props.selectCallback
    };

    var customizationMenuProps = $.extend(defaultProps, {
      startOverCallback: this.props.startOverCallback
    });

    var customizationsContainerProps = $.extend(defaultProps, {
      goToSlideCallback: this.goToSlide,
      customizations: this.props.customizations
    });



    return (
      <div className="customization-experience--mobile hidden-sm hidden-md hidden-lg">
        <div ref="slickHook" className="js-slick-hook">
          <CustomizationsReviewMobile {...this.props}/>
          <CustomizationsMenuMobile {...this.props}/>
          <CustomizationsContainerMobile {...this.props}/>
        </div>
      </div>
    );
  }
});
