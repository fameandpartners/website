var MenuLookbookItem = React.createClass({

  render: function() {
    var link = (this.props.asset.link ? this.props.asset.link : 'javascript:;'),
      title = (this.props.asset.title ? this.props.asset.title : ''),
      src = (this.props.asset.src ? this.props.asset.src : '');
    return (
      <a href={link} className='item-wrap'>
        <div className='title'>{title}</div>
        <div className='media-wrap'>
          <img src={src} />
        </div>  
      </a>
    )
  }

});

var MenuLookbook = React.createClass({

  componentDidMount: function() {
    $('.js-carousel-menu-lookbook').slick({
      speed: 800,
      slidesToShow: 3,
      slidesToScroll: 3
    });
  },

  render: function() {
    var assets;
    if (this.props.assets === 0) {
      return (
        <div></div>
      );
    } else {
      assets = this.props.assets.map(function(asset) {
        return (<MenuLookbookItem asset={asset} />)
      });
      return (
        <div className={'js-carousel-menu-lookbook ' + (this.props.skin ? this.props.skin : '')}>
          {assets}
        </div>
      )
    }
  }

});
