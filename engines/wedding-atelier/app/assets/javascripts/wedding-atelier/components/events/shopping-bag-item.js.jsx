var ShoppingBagItem = React.createClass({
  propTypes: {
    item: React.PropTypes.number //TODO: Change to object
  },

  itemRemovedHandle: function (item) {
    //TODO: Call to endpoint to remove item from cart, check DOM to replace empty object
  },

  render: function () {
    return (
      <li className="shopping-bag-item">
        <img className="shopping-bag-item-image" src="/assets/wedding-atelier/dresses/280x404/FP2212-HG-BERRY-S0-F0-AK-FRONT.jpg" />
        <div className="shopping-bag-item-summary">
          <div className="shopping-bag-item-summary-header">
            <div className="shopping-bag-item-summary-header-delete" onClick={this.itemRemovedHandle.bind(null, {})}></div>
            <p className="dress-name">Sienna Dress</p>
            <p className="dress-cost">$299</p>
          </div>
          <ul className="shopping-bag-item-summary-list">
            <li className="shopping-bag-item-summary-list-item">
              <span className="customization-name">Silhouette: </span>
              <span className="customization-value">The Slip</span>
            </li>
            <li className="shopping-bag-item-summary-list-item">
              <span className="customization-name">Fabric: </span>
              <span className="customization-value">Heavy Georgette</span>
            </li>
            <li className="shopping-bag-item-summary-list-item">
              <span className="customization-name">Color: </span>
              <span className="customization-value">Navy</span>
            </li>
            <li className="shopping-bag-item-summary-list-item">
              <span className="customization-name">Length: </span>
              <span className="customization-value">Something</span>
            </li>
            <li className="shopping-bag-item-summary-list-item">
              <span className="customization-name">Style Addons: </span>
              <span className="customization-value">Something - $10</span>
            </li>
            <li className="shopping-bag-item-summary-list-item">
              <span className="customization-name">Size: </span>
              <span className="customization-value">Janine's Profile</span>
            </li>
          </ul>
        </div>
      </li>
    );
  }
});
