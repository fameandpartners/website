var ShoppingBagItem = React.createClass({
  propTypes: {
    item: React.PropTypes.object.isRequired,
    itemRemovedSuccessHandler: React.PropTypes.func,
    itemRemovedErrorHandler: React.PropTypes.func
  },

  removeItemHandler: function () {
    var that = this;
    $.ajax({
      url: '/user_cart/products/' + this.props.item.id,
      type: 'DELETE',
      dataType: 'json'
    })
    .success(function (data) {
      if(that.props.itemRemovedSuccessHandler) { that.props.itemRemovedSuccessHandler(data, this.item); }
    })
    .error(function (response) {
      if(that.props.itemRemovedErrorHandler) { that.props.itemRemovedErrorHandler(response); }
    });
  },

  prepareSummary: function () {
    var item = $.extend({}, this.props.item);
    var images = new DressImageBuilder(item.personalization).dressCombos();
    var personalization = $.extend({}, this.props.item.personalization);
    personalization.silhouette = {presentation: item.product_name, price: 0};
    return $.extend(item, {
      personalization: personalization,
      imageUrl: images.front.thumbnail.grey,
      price: item.personalization['silhouette'].price
    });
  },

  renderListOfCustomizations: function (item) {
    var renderRow = function(propertyName) {
      var label = propertyName.slice(0,1).toUpperCase() + propertyName.slice(1) + ': ';
      var personalization = item.personalization[propertyName];
      var presentationLabel = propertyName === 'silhouette'? 'The ' : '';
      if(personalization) {
        var key = item.id + '-' + personalization.id;
        presentationLabel += item.personalization[propertyName].presentation + (personalization.price > 0 ? ' - $' + personalization.price : '');
        return (
          <li key={key} className="shopping-bag-item-summary-list-item">
            <span className="customization-name">{label}</span>
            <span className="customization-value">{presentationLabel}</span>
          </li>
        );
      }
    }

    var render = ['silhouette', 'fabric', 'color', 'size', 'length'].map(renderRow);

    if (item.personalization['style'] || item.personalization['fit']) {
      var key = 'base-price-' + item.id;
      var basePrice = (
        <li key="base-price" className="shopping-bag-item-summary-list-item">
          <span className="customization-name">Base Price: </span>
          <span className="customization-value">${item.price}</span>
        </li>
      );
      var withCost = ['style', 'fit'].map(renderRow);
      render = render.concat(basePrice).concat(withCost);
    }

    return render;
  },

  render: function () {
    var item = this.prepareSummary();

    return (
      <li className="shopping-bag-item">
        <img className="shopping-bag-item-image" src={item.imageUrl} />
        <div className="shopping-bag-item-summary">
          <div className="shopping-bag-item-summary-header">
            <div className="shopping-bag-item-summary-header-delete" onClick={this.removeItemHandler}></div>
            <p className="dress-name">{item.product_name}</p>
            <p className="dress-cost">{item.money}</p>
          </div>
          <ul className="shopping-bag-item-summary-list">
            {this.renderListOfCustomizations(item)}
          </ul>
        </div>
      </li>
    );
  }
});
