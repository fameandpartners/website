// var MagazineCarouselItem = React.createClass({
//
//   render: function() {
//     var link = (this.props.asset.link ? this.props.asset.link : 'javascript:;'),
//       copy = (this.props.asset.copy ? this.props.asset.copy : ''),
//       src = (this.props.asset.src ? this.props.asset.src : '');
//     return (
//       <a href={link} className='item-wrap'>
//         <div className='media-wrap'>
//           <img src={src} />
//         </div>
//         <div className='copy txt-truncate-block'>{copy}</div>
//       </a>
//     )
//   }
//
// });
//
// var MagazineCarousel = React.createClass({
//
//   componentDidMount: function() {
//     $('.js-carousel-menu-magazine').slick({
//       speed: 800,
//       slidesToShow: 3,
//       slidesToScroll: 3
//     });
//   },
//
//   render: function() {
//     var assets;
//     if (this.props.assets === 0) {
//       return (
//         <div></div>
//       );
//     } else {
//       assets = this.props.assets.map(function(asset) {
//         return (<MagazineCarouselItem asset={asset} />)
//       });
//       return (
//         <div className={'js-carousel-menu-magazine ' + (this.props.skin ? this.props.skin : '')}>
//           {assets}
//         </div>
//       )
//     }
//   }
//
// });
