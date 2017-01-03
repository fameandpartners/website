var ChatImageMessage = React.createClass({

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
    var m = moment(new Date(time)),
      fromNow = m.fromNow(),
      o = fromNow + ', ' + m.format('hh:mm a');

    return o;
  },

  getTime: function() {
    var formattedDate = '';

    if (this.props.message.time) {
      formattedDate = this.formatDate(this.props.message.time);
    }

    return formattedDate;
  },

  getMessageData: function() {
    return (
      <div className="msg-data">
        <div className="profile">
          <img className="photo" src={this.props.message.profilePhoto} />
          <span className="name">{this.props.message.author}</span>
          <span className="created pull-right">{this.getTime()}</span>
        </div>
      </div>
    );
  },

  render: function() {
    return (
      <div className="msg-image">

        {this.props.showAuthor ? this.getMessageData() : ''}

        <div className="attachment">
          <img src="uploadedimagsource" />
        </div>
      </div>
    );
  }
});
