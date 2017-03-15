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
    eventId: React.PropTypes.number,
    currentUser: React.PropTypes.object,
    event_name: React.PropTypes.string,
    event_path: React.PropTypes.string,
    edit: React.PropTypes.bool,
    initialDress: React.PropTypes.object,
    savedDress: React.PropTypes.bool,
    savedDressCallback: React.PropTypes.func
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
    $('#modal-customizations').modal();
  },

  bagOpenedHandler: function () {
    if(this.state.showSelector && this.state.showContainer) {
      this.close();
    }
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
      closeCallback: this.close,
      currentUser: this.props.currentUser
    });

    return (
      <div className="customization-experience--desktop hidden-xs">
        <CustomizationsHeader
          silhouette={this.props.selectedOptions.silhouette}
          event_name={this.props.event_name}
          event_path={this.props.event_path}
          savedDress={this.props.savedDress}
          bagOpenedCallback={this.bagOpenedHandler}/>
        <div className="customization-panel customizations-menu col-sm-6">
          <CustomizationsMenu {...customizationMenuProps} />
          <CustomizationsContainer {...customizationsContainerProps} />
        </div>
        <div className="customization-panel customizations-preview col-sm-6">
          <DressPreview selectedOptions={$.extend({},this.props.selectedOptions)}/>
        </div>
        <div className="footer">
          <div className="col-sm-12 col-lg-offset-6 col-md-offset-6 col-md-6 col-lg-6">
            <div className="row">
            <div className="results">
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
            <div className="actions text-right">
              <SaveDressButton
                eventId={this.props.eventId}
                selectedOptions={this.props.selectedOptions}
                buttonClass='btn-transparent'
                edit={this.props.edit}
                initialDress={this.props.initialDress}
                currentUser={this.props.currentUser}
                savedDressCallback={this.props.savedDressCallback}
                caption="Save this dress"
                showSavedModal={true}
                />
              <AddToCartButton customizations={this.props.selectedOptions} dress={this.props.initialDress} />
            </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
});
