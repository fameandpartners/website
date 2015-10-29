var Delivery = React.createClass({
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
                {this.props.date}
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
