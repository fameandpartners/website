var ChatSimpleMessage = React.createClass({

  propTypes: {
    message: React.PropTypes.object,
    showAuthor: React.PropTypes.bool,
    isOwnerMessage: React.PropTypes.bool
  },

  getDefaultProps: function() {
    return {
      showAuthor: true,
      isOwnerMessage: null
    };
  },

  formatDate: function(time) {

    if (!time) {
      return '';
    }

    var m = moment(new Date(time)),
      fromNow = m.fromNow(),
      o = fromNow + ', ' + m.format('hh:mm a');

    return o;
  },

  getMessageData: function() {
    var formattedDate = this.formatDate(this.props.message.time);

    return (
      <div className="msg-data">
        <div className="profile">
          <div className="row">
            <div className="col-xs-6">
              <img className="photo" src={this.props.message.profilePhoto} />
              <span className="name">{this.props.message.author}</span>
            </div>
            <div className="col-xs-6">
              <span className="created text-right">{formattedDate}</span>
            </div>
          </div>
        </div>
      </div>
    );
  },

  render: function() {
    return(
      <div className="msg msg-simple">
        <div className="container-fluid">
          <div className="row">
            <div className={this.props.isOwnerMessage ? 'pull-right col-xs-12 col-lg-7' : 'pull-left col-xs-12 col-lg-7'}>
              {this.props.showAuthor ? this.getMessageData() : ''}

              <div className="msg-text">
                {this.props.message.content}
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }
});
