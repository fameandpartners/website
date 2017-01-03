var ChatDressMessage = React.createClass({

  propTypes: {
    message: React.PropTypes.object,
    showAuthor: React.PropTypes.bool
  },

  getDefaultProps: function() {
    return {
      showAuthor: true
    };
  },

  getInitialState: function(){
    return {loveClass: 'icon-unliked'}
  },

  handleLoveIt: function() {
    this.setState({loveClass: 'icon-liked'})
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
    var formattedDate = this.getTime();

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
    var dress = this.props.message.content;
    var loveClass = 'icon-liked';

    return (
      <div className="msg-dress clearfix">
        <div className="row">
          <div className={this.props.isOwnerMessage ? 'pull-right' : 'pull-left'}>
            {this.props.showAuthor ? this.getMessageData() : ''}
            <div className="row chat-dress-tile-container pull-right">
              <div className="col-xs-3 chat-likes-container">
                <div className="likes">
                  <span className={this.state.loveClass} onClick={this.handleLoveIt}></span>
                  <span>({dress.love_count})</span>
                </div>
              </div>

              <div className="col-xs-9">
                <div className="dress-box" key={dress.id}>
                  <div className="dress-box-body text-center">
                    <img className="center-block" src={dress.image}/>
                    <div className="dress-info center-block">
                      <strong>{dress.author}</strong>
                      <span>|</span>
                      <span>{dress.price}</span>
                    </div>
                  </div>
                  <div className="dress-box-footer">
                    <div className="center-block">
                      <button className="btn-add-to-cart">
                        Add to cart
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
});
