var ProductImage = React.createClass({
  render: function(){

    var price;

    if (this.props.product.sale_price !== null || this.props.product.discount !== null) {
      price = <span>
              <span className='original-price'>{this.props.product.price} </span>
              <span className='sale-price'>{this.props.product.sale_price} </span>
              <span className='discount'>SAVE {this.props.product.discount} </span>
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

var LatestTrendsCarousel = React.createClass({

  getInitialState: function() {
    return {products: []}
  },

  componentDidMount: function() {
    $.ajax({
      url: urlWithSitePrefix('/dresses/?order=price_low&limit=14'),
      type: "GET",
      dataType: 'json',
      success: function(collection) {
        this.setState({products: collection.products});
      }.bind(this)
    });
  },

  componentDidUpdate: function() {
    $('.js-carousel-latest-trends').slick({
      speed: 800,
      slidesToShow: 5,
      slidesToScroll: 5,
      responsive: [
        {
          breakpoint: 1024,
          settings: {
            slidesToShow: 4,
            slidesToScroll: 4
          }
        },
        {
          breakpoint: 768,
          settings: {
            slidesToShow: 2,
            slidesToScroll: 2
          }
        }
      ]
    });
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

      container = <div className="js-carousel-latest-trends">
                  {products}
                  </div>

      return (<div>{container}</div>)
    }
  }
});

