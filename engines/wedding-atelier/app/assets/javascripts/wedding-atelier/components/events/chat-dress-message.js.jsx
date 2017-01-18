var ChatDressMessage = React.createClass({

  propTypes: {
    message: React.PropTypes.shape({
      author: React.PropTypes.string,
      content: React.PropTypes.shape({
        author: React.PropTypes.object,
        color: React.PropTypes.object,
        id: React.PropTypes.number,
        likes_count: React.PropTypes.number,
        price: React.PropTypes.string,
        value: React.PropTypes.string,
        liked: React.PropTypes.bool,
        images: React.PropTypes.array
      }),
      profilePhoto: React.PropTypes.string,
      time: React.PropTypes.number,
      type: React.PropTypes.string,
      user_id: React.PropTypes.number
    }),
    showAuthor: React.PropTypes.bool,
    isOwnerMessage: React.PropTypes.bool,
    handleLikeDress: React.PropTypes.func
  },

  getDefaultProps: function() {
    return {
      showAuthor: true,
      isOwnerMessage: null
    };
  },

  getInitialState: function(){
    return {loveClass: 'icon-unliked'}
  },

  handleLoveIt: function() {
    this.props.handleLikeDress(this.props.message.content);
  },

  formatDate: function(time) {
    var m = moment(new Date(time)),
      fromNow = m.fromNow(),
      o = fromNow + ', ' + m.format('hh:mm a');

    return o;
  },

  getTime: function() {
    return this.props.message.time ? this.formatDate(this.props.message.time) : '';
  },

  getMessageData: function() {
    var formattedDate = this.getTime();

    return (
      <div className="msg-data">
        <div className="profile">
          <div className="row">
            <div className="col-xs-6">
              <div className="row">
                <img className="photo" src={this.props.message.profilePhoto} />
                <span className="name">{this.props.message.author}</span>
              </div>
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
    var dress = this.props.message.content;
    var loveClass = dress.liked ? 'icon-liked' : 'icon-unliked';
    var dressPositionStyle = (this.props.isOwnerMessage ? ' pull-right ' : ' pull-left ');

    return (
      <div className="msg msg-dress clearfix">
        <div className="row">
          <div className={'chat-dress-container col-xs-12' + dressPositionStyle}>

            {this.props.showAuthor ? this.getMessageData() : ''}

            <div className="row">
              <div className="col-xs-3 chat-likes-container">
                <div className="likes">
                  <span className={loveClass} onClick={this.handleLoveIt}></span>
                  <span>({dress.likes_count})</span>
                </div>
              </div>

              <div className="col-xs-9">
                <div className="dress-box" key={dress.id}>
                  <div className="dress-box-body text-center">
                    <img className="center-block" src={dress.images[0].moodboard}/>
                    <div className="dress-info center-block">
                      <strong>{dress.title}</strong>
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
