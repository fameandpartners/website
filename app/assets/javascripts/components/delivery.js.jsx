// var DeliveryTime = React.createClass({
//   render: function(){
//     if (this.props.start_date != null){
//       return (
//         <ul>
//           <li>Between {this.props.start_date} and {this.props.end_date}</li>
//         </ul>
//       )
//     } else {
//       return(
//         <ul>
//           <li>Between {this.props.start_date_express} and {this.props.end_date_express}
//             <em> for express making dresses</em></li>
//           <li>Between {this.props.start_date_non_express} and {this.props.end_date_non_express}
//             <em> for standard making dresses</em></li>
//         </ul>
//       )
//     }
//   }
// })
// var Delivery = React.createClass({
//   getInitialState: function() {
//     return {date: ""}
//   },
//   componentDidMount: function() {
//     if (this.props.date == null){
//       $.get(urlWithSitePrefix("/user_cart/order_delivery_date"), function(result) {
//         this.setState({start_date:               result.start_date})
//         this.setState({end_date:                 result.end_date})
//         this.setState({start_date_express:       result.start_date_express})
//         this.setState({end_date_express:         result.end_date_express})
//         this.setState({start_date_non_express:   result.start_date_non_express})
//         this.setState({end_date_non_express:     result.end_date_non_express})
//       }.bind(this));
//     } else {
//       this.setState({date: this.props.date});
//     }
//   },
//   render: function() {
//     return(
//       <div className="row">
//         <div className="col-md-12">
//           <div className="delivery-wrap">
//             <div className="inner-wrap">
//               <span className="icon icon-delivery-express"></span>
//               <div>
//                 <div className="title">Delivery Guaranteed*</div>
//                 <DeliveryTime start_date={this.state.start_date} end_date={this.state.end_date} start_date_express={this.state.start_date_express} end_date_express={this.state.end_date_express} start_date_non_express={this.state.start_date_non_express} end_date_non_express={this.state.end_date_non_express}/>
//               </div>
//             </div>
//           </div>
//         </div>
//       </div>
//     )
//   }
//
// });
