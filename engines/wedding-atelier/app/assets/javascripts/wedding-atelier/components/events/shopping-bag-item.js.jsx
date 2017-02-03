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
      imageUrl: images.front.thumbnail.grey
    });
  },

  renderListOfCustomizations: function (item) {
    var renderRow = function(propertyName, index) {
      var label = propertyName.slice(0,1).toUpperCase() + propertyName.slice(1) + ': ';
      var key = item.id + '-' + index;
      var personalization = item.personalization[propertyName];
      var presentationLabel = '';
      if(personalization) {
        presentationLabel = item.personalization[propertyName].presentation + (personalization.price > 0 ? ' - $' + personalization.price : '');
        return (
          <li key={key} className="shopping-bag-item-summary-list-item">
            <span className="customization-name">{label}</span>
            <span className="customization-value">{presentationLabel}</span>
          </li>
        );
      }
    }

    var withoutCost = ['silhouette', 'fabric', 'color', 'size', 'length'].map(renderRow);
    return withoutCost.concat([]);
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
