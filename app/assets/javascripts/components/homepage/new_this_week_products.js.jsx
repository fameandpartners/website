var ProductImageMobile = React.createClass({
  render: function(){
    return(
      <div className='col-xxs-6 col-xs-6 category--item'>
        <a href={urlWithSitePrefix(this.props.product.collection_path)}>
          <img alt={this.props.product.name} className='img-product img-responsive' data-hover={this.props.product.images[0]} src={this.props.product.images[1]}></img>
          <div className='details text-center'>
            <span className='name'> {this.props.product.name} </span>
            <span className='price'> {this.props.product.price} </span>
          </div>
        </a>
      </div>
    )
  }
});

var ProductImageDesktop = React.createClass({
  render: function(){
    return(
      <a href={urlWithSitePrefix(this.props.product.collection_path)}>
        <img alt={this.props.product.name} className='img-product img-responsive' data-hover={this.props.product.images[0]} src={this.props.product.images[1]}></img>
      </a>
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
    $('.slideArea .new-this-week-rslides').responsiveSlides({
      auto: false,
      nav: true
    })
  },

  render: function() {

    if (this.state.products.length == 0){
      return (
        <div></div>
      );
    } else {
      if (this.props.device == 'mobile') {
        products = this.state.products.map(function(product){
          return (<ProductImageMobile product={product} />)
        });
      } else if (this.props.device == 'desktop'){
        products_first_slide = this.state.products.slice(0,5);
        products_first_slide = products_first_slide.map(function(product){
          return (<ProductImageDesktop product={product} />)
        });

        products_second_slide = this.state.products.slice(5,11);
        products_second_slide = products_second_slide.map(function(product){
          return (<ProductImageDesktop product={product} />)
        });

        products = (
          <ul className='new-this-week-rslides'>
            <li>{products_first_slide}</li>
            <li>{products_second_slide}</li>
          </ul>
        )
      }

      return (
        <div>{products}</div>
      )
    }
  }
});

