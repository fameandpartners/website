function initProductDetailsStore() {

  if(typeof altFlux === 'undefined') {
    window.altFlux = new Alt();

    var ProductDetailsActions = altFlux.createActions(function() {
      this.updateSelectedColor = function(selectedColor) {
        return selectedColor;
      };
    });

    function ProductDetailsStore() {
      this.productDetails = window.ProductDetails || {};
      this.selectedColor = window.ProductDetails.selectedColor || '';
      this.colorOptions = window.ProductDetails.colorOptions || [];
      this.productImages = window.ProductDetails.productImages || [];

      this.bindListeners({
        handleUpdateSelectedColor: ProductDetailsActions.UPDATE_SELECTED_COLOR
      });
    };

    ProductDetailsStore.prototype.handleUpdateSelectedColor = function(selectedColor) {
      this.selectedColor = selectedColor;
    };

    window.ProductDetailsActions = altFlux.createActions(ProductDetailsActions);
    window.ProductDetailsStore = altFlux.createStore(ProductDetailsStore);
  }

}

var DetailsColorSelector = React.createClass({

  updateSelectedColor: function(e) {
    var colorId = Number(e.target.getAttribute('data-id'));
    ProductDetailsActions.updateSelectedColor(colorId);
  },

  render: function() {
    var colorClasses = 'option-box color-box color-' + this.props.color.table.name;
    return (
      <a onClick={this.updateSelectedColor} 
        href='javascript:;' 
        className='col-md-6 color-option product-option'
        data-name={this.props.color.table.presentation} 
        data-id={this.props.color.table.id}>
        <span className={colorClasses} 
          data-name={this.props.color.table.presentation} 
          data-id={this.props.color.table.id}></span>
        <span className='option-name'>{this.props.color.table.presentation}</span>
      </a>
    )
  }

});

var DetailsRecColors = React.createClass({

  getInitialState: function() {
    initProductDetailsStore();
    return ProductDetailsStore.getState();
  },

  componentDidMount: function() {
    ProductDetailsStore.listen(this.onChange);
  },

  componentWillUnmount: function() {
    ProductDetailsStore.unlisten(this.onChange);
  },

  onChange: function(state) {
    this.setState(state);
  },

  render: function() {
    colors = this.state.colorOptions.map(function(color) {
      return (<DetailsColorSelector key={'color-' + color.table.id} color={color} />)
    });
    return (
      <div>{colors}</div>
    )
  }

});

var HeroProductCarouselImage = React.createClass({

  render: function() {
    return (
      <div className='media-wrap'>
        <img src={this.props.asset.url} alt={this.props.asset.alt} />
      </div>
    )
  }

});

var HeroProductCarousel = React.createClass({

  getInitialState: function() {
    initProductDetailsStore();
    return ProductDetailsStore.getState();
  },

  componentDidMount: function() {
    ProductDetailsStore.listen(this.onChange);
    this.initGallery();
  },

  componentWillUpdate: function() {
    $('.js-carousel-hero-product').slick('unslick');
    $('.js-carousel-hero-product-nav').slick('unslick');
  },

  componentDidUpdate: function() {
    this.initGallery();
  },

  componentWillUnmount: function() {
    ProductDetailsStore.unlisten(this.onChange);
  },

  onChange: function(state) {
    this.setState(state);
  },

  initGallery: function() {

    $('.js-carousel-hero-product').slick({
      autoplay: true,
      pauseOnHover: true,
      autoplaySpeed: 8000,
      speed: 1000,
      fade: true,
      arrows: false,
      asNavFor: '.js-carousel-hero-product-nav'
    });

    $('.js-carousel-hero-product-nav').slick({
      slidesToShow: 5,
      slidesToScroll: 1,
      asNavFor: '.js-carousel-hero-product',
      centerPadding: 0,
      vertical: true,
      arrows: false,
      focusOnSelect: true,
      autoplay: true
    });

    $('.js-carousel-hero-product').on('afterChange', function(event, slick, direction) {
      $('.js-carousel-hero-product-nav .slick-active:eq(' + slick.currentSlide + ')')
        .addClass('slick-current').siblings().removeClass('slick-current');
    });

    $('.js-carousel-hero-product').on('touchstart', function(event) {
      $('.js-carousel-hero-product').slick('slickPause');
    });

    $('.js-carousel-hero-product').on('touchend', function(event) {
      $('.js-carousel-hero-product').slick('slickPlay');
    });

    $('.js-zoom-trigger').one('click', function() {
        $this = $(this);
        if(!$this.hasClass()) {
          $this.addClass('active');
          console.log('jghgh');
          $('.js-carousel-hero-product img').mlens({
            zoomLevel: parseFloat(window.innerWidth / 1000).toFixed(1),
            borderColor: '#fff',
            borderSize: 3,
            lensSize: ['200px', '200px']
          });
      }
    });

  },

  render: function() {
    var selectedColor = this.state.selectedColor;
    if (this.state.productImages.length === 0) {
      return (
        <div></div>
      );
    } else {
      assets = this.state.productImages.map(function(asset) {
        if (selectedColor === asset.color_id) {
          return (<HeroProductCarouselImage key={'image-' + asset.id} asset={asset} />)
        }
      });
      return (
        <div className='js-hero-product-carousel'>
          <div className='carousel-product'>
            <div className='js-carousel-hero-product'>
              {assets}
            </div>
          </div>
          <div className='carousel-nav'>
            <div className='outer-wrap'>
              <div className='inner-wrap'>
                <div className='js-carousel-hero-product-nav'>
                  {assets}
                </div>
              </div>
            </div>
          </div>
          <a href='javascript:;'  className='zoom-trigger icon icon-zoom-in js-zoom-trigger'></a>
        </div>
      )
    }
  }

});
