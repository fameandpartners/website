var ChatImageMessage = React.createClass({

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

  componentWillMount: function() {
    var src = "https://process.filestackapi.com/AwsXNEkqXSG61itbPhj5nz/resize=width:200/" + this.props.message.content.url;
    this.setState({src: src});
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
      <div className="msg msg-image">
        <div className="row">
          <div className={this.props.isOwnerMessage ? 'pull-right col-xs-10 col-md-7' : 'pull-left col-xs-10 col-md-7'}>
            {this.props.showAuthor ? this.getMessageData() : ''}

            <div className="attachment">
              <img src={this.state.src} />
            </div>
          </div>
        </div>
      </div>
    );
  }
});
