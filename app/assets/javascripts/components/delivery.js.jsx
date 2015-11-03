var DeliveryTime = React.createClass({
  render: function(){
    if (this.props.start_date != null){
      return (
        <span className="time-bold">
          {this.props.start_date} - {this.props.end_date}
        </span>
      )
    } else {
      return(
        <span className="time-bold">
          <div className="clearfix">{this.props.start_date_express} - {this.props.end_date_express} for express making dresses</div>
          <div className="clearfix">{this.props.start_date_non_express} - {this.props.end_date_non_express} for express standard making dresses</div>
        </span>
      )
    }
  }
})
var Delivery = React.createClass({
  getInitialState: function() {
    return {date: ""}
  },
  componentDidMount: function() {
    if (this.props.date == null){
      $.get(urlWithSitePrefix("/user_cart/order_delivery_date"), function(result) {
        this.setState({start_date:               result.start_date})
        this.setState({end_date:                 result.end_date})
        this.setState({start_date_express:       result.start_date_express})
        this.setState({end_date_express:         result.end_date_express})
        this.setState({start_date_non_express:   result.start_date_non_express})
        this.setState({end_date_non_express:     result.end_date_non_express})
      }.bind(this));
    } else {
      this.setState({date: this.props.date});
    }
  },
  render: function() {
    return(
      <div className="row delivered-row">
        <div className={this.props.terms + " col-xs-6 col-sm-6 col-md-6 delivery-time"}>
          <div className="col-xs-2 col-sm-2 col-md-2 icon-delivery-express">
          </div>
          <div className="truck"></div>
          <div className="col-xs-10 col-sm-10 col-md-10 left-col">
            <div className="head">
              Delivery time
            </div>
            <div className="tail">
              <span className="get-your">
                Get your dress by the
              </span>
              <span className="time-bold">
                <DeliveryTime start_date={this.state.start_date} end_date={this.state.end_date} start_date_express={this.state.start_date_express} end_date_express={this.state.end_date_express} start_date_non_express={this.state.start_date_non_express} end_date_non_express={this.state.end_date_non_express}/>
              </span>
            </div>

          </div>
        </div>
        <div className={this.props.color +" "+ this.props.terms+ " col-xs-6 col-sm-6 col-md-6 delivery-time-text"}>
          <span className="right-col">
            <div className="clock"></div>
            <div className="text guaranteed">
              Delivery time guaranteed
            </div>
            <div className="text">
              <div className="terms">Terms and conditions apply</div>
            </div>
          </span>
          <span className="triangle"></span>
        </div>
      </div>
    )
  }

});
