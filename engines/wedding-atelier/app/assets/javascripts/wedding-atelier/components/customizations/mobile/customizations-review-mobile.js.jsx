var CustomizationsReviewMobile = React.createClass({
  propTypes: {
    changeCurrentCustomizationCallback: React.PropTypes.func,
    currentCustomization: React.PropTypes.string,
    customizations: React.PropTypes.object,
    selectCallback: React.PropTypes.func,
    selectedOptions: React.PropTypes.object,
    siteVersion: React.PropTypes.string,
    goToSlide: React.PropTypes.func,
    currentUser: React.PropTypes.object
  },

  getInitialState: function () {
    return {
      showSizing: false
    };
  },

  showSizing: function (value) {
    this.setState({showSizing: value});
  },

  render: function() {
    var selectedOptions = this.props.selectedOptions;
    var selectedValue = 'select size';
    if(selectedOptions.size && selectedOptions.height) {
      selectedValue = PresentationHelper.size(selectedOptions.size, selectedOptions.height, this.props.siteVersion);
    }

    return (
      <div className="customizations-review-mobile">
        <CustomizationsHeader {...this.props.selectedOptions.silhouette}/>
        <div className="customizations-review-mobile-body">
          <h1>You are designing the  {this.props.selectedOptions.silhouette? this.props.selectedOptions.silhouette.name : ''}</h1>
          <DressPreview selectedOptions={this.props.selectedOptions}/>
          <button className="btn-transparent" onClick={this.props.goToSlide.bind(null, 1)}>customize dress</button>
          <button className="btn-transparent" onClick={this.showSizing.bind(null, true)}>{selectedValue}</button>
          <div className="customizations-review-mobile-results">
            <p>
              <span className="view-customizations">View customizations</span>
              <span className="view-customizations-total">$16</span>
            </p>
            <p>
              <span className="sub-total-label">Sub-total</span>
              <span className="sub-total-value">$320</span>
            </p>
            <p className="estimated-delivery">
              Estimated delivery {7} days
            </p>
          </div>
        </div>
        <div className="customizations-selector-mobile-actions-double">
          <button className="btn-gray">save to board</button>
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
          currentUser={this.props.currentUser}
           />
      </div>
    );
  }
});
