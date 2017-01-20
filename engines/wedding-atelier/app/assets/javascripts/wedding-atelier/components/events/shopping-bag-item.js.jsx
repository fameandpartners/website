var ShoppingBagItem = React.createClass({
  propTypes: {
    item: React.PropTypes.object.isRequired,
    itemRemovedHandler: React.PropTypes.func.isRequired
  },

  prepareSummary: function () {
    var props = $.extend({}, this.props.item);
    var customizations = {};
    props.personalization.customization_values.forEach(function (customization) {
      customizations[customization.type] = customization.presentation + (customization.price > 0 ? '- $' + customization.price : '');
    });
    return $.extend(customizations, {
      imageUrl: props.image_small,
      dressName: props.product_name,
      dressCost: props.money,
      silouette: props.product_name,
      size: props.personalization.size.option_value.presentation
    });
  },

  renderListOfCustomizations: function (item) {
    return ['silhouette', 'fabric', 'color', 'length', 'style', 'size'].map(function (customization, index) {
      var label = customization.slice(0,1).toUpperCase() + customization.slice(1) + ': ';
      var key = item.id + '-' + customization;
      return (
        <li key={key} className="shopping-bag-item-summary-list-item">
          <span className="customization-name">{label}</span>
          <span className="customization-value">{item[customization]}</span>
        </li>
      );
    });
  },

  render: function () {
    var item = this.prepareSummary();

    return (
      <li className="shopping-bag-item">
        <img className="shopping-bag-item-image" src={item.imageUrl} />
        <div className="shopping-bag-item-summary">
          <div className="shopping-bag-item-summary-header">
            <div className="shopping-bag-item-summary-header-delete" onClick={this.props.itemRemovedHandler.bind(null, this.props.item.id)}></div>
            <p className="dress-name">{item.dressName}</p>
            <p className="dress-cost">{item.dressCost}</p>
          </div>
          <ul className="shopping-bag-item-summary-list">
            {this.renderListOfCustomizations(item)}
          </ul>
        </div>
      </li>
    );
  }
});
