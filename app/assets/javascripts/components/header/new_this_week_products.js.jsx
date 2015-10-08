var ProductImage = React.createClass({
  render: function(){

    var price;

    if (this.props.product.sale_price !== null || this.props.product.discount !== null) {
      price = <span>
              <span className='original-price'>{this.props.product.price} </span>
              <span className='sale-price'>{this.props.product.sale_price} </span>
              <span className='discount'>SAVE {this.props.product.discount.table.amount}% </span>
              </span>;
    } else {
      price = <span>{this.props.product.price}</span>;
    }

    return(
      <div className='item-wrap'>
        <a href={urlWithSitePrefix(this.props.product.collection_path)}>
          <div className='media-wrap'>
            <img alt={this.props.product.name} data-hover={this.props.product.images[0]} src={this.props.product.images[1]}></img>
          </div>
          <div className='details-wrap'>
            <span> {this.props.product.name} </span>
            <span className='price-wrap'>{price}</span>
          </div>
        </a>
      </div>
    )
  }

});

var NewThisWeekProducts = React.createClass({

  getInitialState: function() {
    return {products: []}
  },

  componentDidMount: function() {
    $.ajax({
      url: urlWithSitePrefix('/dresses/?order=newest&limit=10'),
      type: "GET",
      dataType: 'json',
      success: function(collection) {
        this.setState({products: collection.products});
      }.bind(this)
    });
  },

  componentDidUpdate: function() {
    if (this.props.device === 'desktop') {
      $('.js-carousel-new-this-week').slick({
        speed: 800
      });
    }
  },

  render: function() {
    var container;
    if (this.state.products.length == 0){
      return (
        <div></div>
      );
    } else {
      products = this.state.products.map(function(product){
        return (<ProductImage product={product} />)
      });

      if (this.props.device === 'desktop') {
        container = <div className="js-carousel-new-this-week" data-slick='{"slidesToShow": 5, "slidesToScroll": 5}'>
                    {products}
                    </div>
      } else {
        container = <div>{products}</div>
      }

      return (<div>{container}</div>)
    }
  }
});

