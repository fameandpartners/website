var CustomizationsReviewMobile = React.createClass({
  propTypes: {
    changeCurrentCustomizationCallback: React.PropTypes.func,
    currentCustomization: React.PropTypes.string,
    customizations: React.PropTypes.object,
    selectCallback: React.PropTypes.func,
    selectedOptions: React.PropTypes.object,
    siteVersion: React.PropTypes.string,
    goToSlide: React.PropTypes.func,
    subTotal: React.PropTypes.number,
    customizationsCost: React.PropTypes.number,
    eventSlug: React.PropTypes.string,
    currentUser: React.PropTypes.object,
    event_name: React.PropTypes.string,
    event_path: React.PropTypes.string,
    edit: React.PropTypes.bool,
    initialDress: React.PropTypes.object
  },

  getInitialState: function () {
    return {
      showSizing: false
    };
  },

  showSizing: function (value) {
    this.setState({showSizing: value});
  },

  viewCustomizations: function(){
    $('#modal-customizations').modal();
  },

  render: function() {
    var selectedOptions = this.props.selectedOptions;
    var selectedValue = PresentationHelper.presentation(selectedOptions, 'size', this.props.siteVersion);

    return (
      <div className="customizations-review-mobile">
        <CustomizationsHeader {...this.props.selectedOptions.silhouette} event_name={this.props.event_name} event_path={this.props.event_path} />
        <div className="customizations-review-mobile-body">
          <h1>You are designing The {this.props.selectedOptions.silhouette? this.props.selectedOptions.silhouette.name : ''}</h1>
          <DressPreview selectedOptions={$.extend({},this.props.selectedOptions)} />
          <button className="btn-transparent" onClick={this.props.goToSlide.bind(null, 1)}>customize</button>
          <button className="btn-transparent" onClick={this.showSizing.bind(null, true)}>{selectedValue || 'Select Size'}</button>
          <div className="customizations-review-mobile-results">
            <p>
              <span className="view-customizations" onClick={this.viewCustomizations}>Customizations</span>
              <span className="view-customizations-total">${this.props.customizationsCost}</span>
            </p>
            <p>
              <span className="sub-total-label">Sub-total</span>
              <span className="sub-total-value">${this.props.subTotal}</span>
            </p>
            <p className="estimated-delivery">
              Estimated delivery 3-4 weeks
            </p>
          </div>
        </div>
        <div className="customizations-selector-mobile-actions-double">
          <SaveDressButton
            eventSlug={this.props.eventSlug}
            selectedOptions={this.props.selectedOptions}
            mobile={true}
            edit={this.props.edit}
            initialDress={this.props.initialDress}
            currentUser={this.props.currentUser}
            />
          <button className="btn-black">add to cart</button>
        </div>
        <SizeSelectorMobile
          sizes={this.props.customizations.sizes}
          assistants={this.props.customizations.assistants}
          heights={this.props.customizations.heights}
          siteVersion={this.props.siteVersion}
          selectCallback={this.props.selectCallback}
          showSizing={this.state.showSizing}
          showSizingCallback={this.showSizing}
          currentUser={this.props.currentUser}/>
      </div>
    );
  }
});
