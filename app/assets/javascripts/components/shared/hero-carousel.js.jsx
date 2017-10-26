// var HeroCarouselImage = React.createClass({
//
//   render: function() {
//     var link = (this.props.asset.link ? this.props.asset.link : 'javascript:;'),
//       alt = (this.props.asset.alt ? this.props.asset.alt : ''),
//       src = (this.props.asset.src ? this.props.asset.src : ''),
//       srcSet = src + '-sml.jpg 768w, ' + src + '-med.jpg 1024w, ' + src + '-full.jpg 1200w',
//       srcFull = src + '-full.jpg';
//     return (
//       <a href={link} className='media-wrap'>
//         <img src={srcFull} srcSet={srcSet} alt={alt} />
//       </a>
//     )
//   }
//
// });
//
// var HeroCarousel = React.createClass({
//
//   componentDidMount: function() {
//     $('.js-carousel-hero').slick({
//       autoplay: true,
//       autoplaySpeed: 8000,
//       speed: 1500,
//       fade: true,
//       responsive: [
//         {
//           breakpoint: 768,
//           settings: {
//             speed: 800,
//             fade: false,
//             arrows: false,
//             slidesToShow: 1,
//             slidesToScroll: 1
//           }
//         }
//       ]
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
//         return (<HeroCarouselImage key={asset.src} asset={asset} />)
//       });
//       return (
//         <div className={'hero-wrap js-carousel-hero ' + (this.props.skin ? this.props.skin : '')}>
//           {assets}
//         </div>
//       )
//     }
//   }
//
// });
//
