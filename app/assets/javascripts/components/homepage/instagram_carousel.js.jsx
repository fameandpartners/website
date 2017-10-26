// var InstagramItem = React.createClass({
//
//   render: function() {
//     var link = (this.props.asset.link ? this.props.asset.link : 'javascript:;'),
//       user = (this.props.asset.user ? this.props.asset.user : ''),
//       cta = (this.props.asset.cta ? this.props.asset.cta : ''),
//       src = (this.props.asset.src ? this.props.asset.src : '');
//     return (
//       <a href={link} className='item-wrap'>
//         <div className='media-wrap'>
//           <img data-lazy={src} />
//           <div className='overlay'>
//             <div className='overlay-outer-wrap'>
//               <div className='overlay-inner-wrap'>
//                 <span className='icon icon-instagram'></span>
//                 <span className='CTA'>{cta}</span>
//               </div>
//             </div>
//           </div>
//         </div>
//         <div className='user'>{user}</div>
//       </a>
//     )
//   }
//
// });
//
// var InstagramCarousel = React.createClass({
//
//   componentDidMount: function() {
//     $('.js-carousel-instagram').slick({
//       lazyLoad: 'ondemand',
//       speed: 800,
//       slidesToShow: 5,
//       slidesToScroll: 5,
//       responsive: [
//         {
//           breakpoint: 1024,
//           settings: {
//             slidesToShow: 4,
//             slidesToScroll: 4
//           }
//         },
//         {
//           breakpoint: 768,
//           settings: {
//             arrows: false,
//             centerMode: true,
//             centerPadding: '30px',
//             slidesToShow: 2,
//             slidesToScroll: 2
//           }
//         },
//         {
//           breakpoint: 480,
//           settings: {
//             arrows: false,
//             centerMode: true,
//             centerPadding: '20px',
//             slidesToShow: 2,
//             slidesToScroll: 2
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
//         return (<InstagramItem key={asset.src} asset={asset} />)
//       });
//       return (
//         <div className={'js-carousel-instagram ' + (this.props.skin ? this.props.skin : '')}>
//           {assets}
//         </div>
//       )
//     }
//   }
//
// });
