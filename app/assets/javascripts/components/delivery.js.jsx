var DeliveryTime = React.createClass({
  render: function(){
    if (this.props.date != null){
      return (
        <span className="time-bold">
          {this.props.date}
        </span>
      )
    } else {
      return(
        <span className="time-bold">
          <div className="clearfix">{this.props.date_express} for express making dresses</div>
          <div className="clearfix">{this.props.date_non_express} for express standard making dresses</div>
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
        this.setState({date:             result.date})
        this.setState({date_express:     result.date_express})
        this.setState({date_non_express: result.date_non_express})
      }.bind(this));
    } else {
      this.setState({date: this.props.date});
    }
  },
  render: function() {
    return(
      <div className="row delivered-row">
        <div className="col-xs-6 col-sm-6 col-md-6 delivery-time">
          <div className="col-xs-2 col-sm-2 col-md-2 icon-delivery-express">
          </div>
          <div className="col-xs-10 col-sm-10 col-md-10 left-col">
            <div className="head">
              Delivery time
            </div>
            <div className="tail">
              <span>
                Get your dress by the
              </span>
              <span className="time-bold">
                <DeliveryTime date={this.state.date} date_express={this.state.date_express} date_non_express={this.state.date_non_express}/>
              </span>
            </div>

          </div>
        </div>
        <div className={this.props.color +" "+ this.props.terms+ " col-xs-6 col-sm-6 col-md-6 delivery-time-text"}>
          <span className="right-col">
            <div className={this.props.color+ " clock" }></div>
            <div className="text">
              Delivery time guaranteed
            </div>
            <div className="text">
              <span>or receive a </span>
              <span className="bold-text">25% cashback</span>
              <div className={this.props.terms+" terms"}>Terms and conditions apply</div>
            </div>
          </span>
          <span className="triangle"></span>
        </div>
      </div>
    )
  }

});
