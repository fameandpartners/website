/* eslint-disable */
// /*TODO : REFACTOR THIS COMPONENT BY MERGING IT WITH THE COMPONENT IN new_this_week_products.js.jsx AND
// USE PROPS TO CONTROL THE DISPLAY OF MOODBOARD FEATURES. AFTER THAT , PUT THIS COMPONENT TO SEPERATED JS.JSX FILE*/
//
// var ProductsCarouselElement = React.createClass({
//   render: function(){
//     var price;
//
//     if (this.props.product.prices.sale_string !== null) {
//       price = <span>
//               <span className='original-price'>{this.props.product.prices.original_string} </span>
//               <span className='sale-price'>{this.props.product.prices.sale_string} </span>
//               <span className='discount'>SAVE {this.props.product.prices.discount_string} </span>
//               </span>;
//     } else {
//       price = <span>{this.props.product.prices.original_string}</span>;
//     }
//
//     return(
//       <div className='item-wrap'>
//         <a href={urlWithSitePrefix(this.props.product.collection_path)} data-id={this.props.product.id}>
//           <div className='media-wrap'>
//             <img alt={this.props.product.name} data-hover={this.props.product.images[1]} src={this.props.product.images[0]}></img>
//           </div>
//           <div className='details-wrap'>
//             <span> {this.props.product.name} </span>
//             <span className='price-wrap'>{price}</span>
//           </div>
//         </a>
//          {/* TODO: add to moodboard functionality
//         <a href='javascript:;' className='moodboard'>+ moodboard</a> */}
//       </div>
//     )
//   }
//
// });
//
// var ProductsCarousel = React.createClass({
//
//   getInitialState: function() {
//     return {products: []}
//   },
//
//   componentDidMount: function() {
//     var path = this.props.path ? this.props.path : '/dresses/?order=price_low&limit=16';
//
//     $.ajax({
//       url: urlWithSitePrefix(path),
//       type: "GET",
//       dataType: 'json',
//       success: function(collection) {
//         this.setState({products: collection.products});
//       }.bind(this)
//     });
//   },
//
//   componentDidUpdate: function() {
//     $('.js-carousel-products').slick({
//       lazyLoad: 'ondemand',
//       speed: 800,
//       slidesToShow: 4,
//       slidesToScroll: 4,
//       responsive: [
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
//     var container;
//     if (this.state.products.length == 0){
//       return (
//         <div></div>
//       );
//     } else {
//       products = this.state.products.map(function(product){
//         return (<ProductsCarouselElement product={product} />)
//       });
//
//       container = <div className="js-carousel-products">
//                   {products}
//                   </div>
//
//       return (<div>{container}</div>)
//     }
//   }
// });
