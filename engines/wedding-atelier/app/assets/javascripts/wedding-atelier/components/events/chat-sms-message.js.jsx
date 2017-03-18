var ChatSMSMessage = React.createClass({

  render: function() {
    return(
      <div className="msg msg-sms">
        <div className="container-fluid">
          <div className="row">
            <div className="pull-left col-xs-12 col-lg-7">
              <div className="msg-text">
                <p>Also get notified by SMS</p>
                <input type="phone" className="sms-phone-number"/>
                <a href="javascript:;" className="btn btn-black send-sms">></a>
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
});
