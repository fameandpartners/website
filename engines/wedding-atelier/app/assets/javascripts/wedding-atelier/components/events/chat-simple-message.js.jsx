var ChatSimpleMessage = React.createClass({

  propTypes: {
    message: React.PropTypes.object,
    showAuthor: React.PropTypes.bool
  },

  getDefaultProps: function() {
    return {
      showAuthor: true
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
          <img className="photo" src={this.props.message.profilePhoto} />
          <span className="name">{this.props.message.author}</span>
          <span className="created pull-right">{formattedDate}</span>
        </div>
      </div>
    );
  },

  render: function() {
    return(
        <div className="msg-simple">
          {this.props.showAuthor || this.props.showAuthor === undefined ? this.getMessageData() : ''}
          <div className="msg-text">
            {this.props.message.content}
          </div>
        </div>
    )
  }
});
