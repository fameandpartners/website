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
        <CustomizationsHeaderMobile />
        <div className="customizations-review-container"></div>
        <div className="customizations-review-actions"></div>
      </div>
    );
  }
});
