var ChatSimpleMessage = React.createClass({

  propTypes: {
    message: React.PropTypes.object
  },

  formatDate: function(time) {
    var m = moment(new Date(time)),
      fromNow = m.fromNow(),
      o = fromNow + ', ' + m.format('hh:mm a');

    return o;
  },

  render: function() {
    if (this.props.message.time) {
      var formattedDate = this.formatDate(this.props.message.time);
    } else {
      formattedDate = ''
    }

    return(
        <div className="msg-simple">
          <div className="msg-data">
            <div className="profile">
              <img className="photo" src={this.props.message.profilePhoto} />
              <span className="name">{this.props.message.author}</span>
              <span className="created pull-right">{formattedDate}</span>
            </div>
          </div>
          <div className="msg-text">
            {this.props.message.content}
          </div>
        </div>
    )
  }
});
