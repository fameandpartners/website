var CustomizationsReviewMobile = React.createClass({
  propTypes: {

  },

  render: function() {
    return (
      <div className="customizations-mobile-review">
        {/* <NavBar/> */}
        <h1>You are designing {"[DRESS_NAME]"}</h1>
        <DressPreview />
        <button className="btn-transparent btn-block js-customize-dress">
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
    );
  }
});
