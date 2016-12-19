var CustomizationsReviewMobile = React.createClass({
  propTypes: {
    currentCustomization:               React.PropTypes.string,
    selectedOptions:                    React.PropTypes.object,
    customizations:                     React.PropTypes.object,
    changeCurrentCustomizationCallback: React.PropTypes.func,
    selectCallback:                     React.PropTypes.func,
    startOverCallback:                  React.PropTypes.func
  },

  render: function() {
    return (
      <div className="customizations-review-mobile">
        <CustomizationsHeader {...this.props.selectedOptions.silhouette}/>
        <div className="customizations-review-mobile-container">
          <h1>You are designing the  {this.props.selectedOptions.silhouette? this.props.selectedOptions.silhouette.name : ''}</h1>
          <DressPreviewMobile />
          <button className="btn-transparent">customize dress</button>
          <button className="btn-transparent">select size</button>
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
        <div className="customizations-review-mobile-actions">
          <button className="btn-gray">save to board</button>
          <button className="btn-black">add to cart</button>
        </div>
      </div>
    );
  }
});
