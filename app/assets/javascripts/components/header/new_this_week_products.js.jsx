// var NewThisWeekProduct = React.createClass({
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
//         <a href={urlWithSitePrefix(this.props.product.collection_path)}>
//           <div className='media-wrap'>
//             <img alt={this.props.product.name}
//               src={this.props.product.images[0].replace(/\/large\//, '/product/')}></img>
//           </div>
//           <div className='details-wrap'>
//             <span> {this.props.product.name} </span>
//             <span className='price-wrap'>{price}</span>
//           </div>
//         </a>
//       </div>
//     )
//   }
//
// });
//
// var NewThisWeekProducts = React.createClass({
//
//   getInitialState: function() {
//     return {products: []}
//   },
//
//   componentDidMount: function() {
//     this.setState({products: newThisWeekProducts});
//   },
//
//   render: function() {
//     var show = this.props.show ? this.props.show : 4;
//
//     if (this.state.products.length == 0){
//       return (
//         <div></div>
//       );
//     } else {
//       products = this.state.products.slice(0, show);
//       products = products.map(function(product){
//         return (<NewThisWeekProduct key={product.collection_path} product={product} />)
//       });
//
//       return (<div>{products}</div>)
//     }
//   }
// });
//
