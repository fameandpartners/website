var CustomizationsReviewMobile = React.createClass({
  propTypes: {
    changeCurrentCustomizationCallback:     React.PropTypes.func,
    currentCustomization:                   React.PropTypes.string,
    customizations:                         React.PropTypes.object,
    selectCallback:                         React.PropTypes.func,
    selectedOptions:                        React.PropTypes.object,
    goToSlide:                              React.PropTypes.func
  },

  showSizing: function () {
    $(ReactDOM.findDOMNode(this.refs.size)).addClass('animate');
  },

  render: function() {

    return (
      <div className="customizations-review-mobile">
        <CustomizationsHeader {...this.props.selectedOptions.silhouette}/>
        <div className="customizations-review-mobile-container">
          <h1>You are designing the  {this.props.selectedOptions.silhouette? this.props.selectedOptions.silhouette.name : ''}</h1>
          <DressPreviewMobile />
          <button className="btn-transparent" onClick={this.props.goToSlide.bind(null, 1)}>customize dress</button>
          <button className="btn-transparent" onClick={this.showSizing}>select size</button>
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
          ref="size" />
      </div>
    );
  }
});
