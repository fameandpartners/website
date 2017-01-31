var ChatDressMessage = React.createClass({

  propTypes: {
    message: React.PropTypes.shape({
      author: React.PropTypes.string,
      content: React.PropTypes.shape({
        author: React.PropTypes.string,
        color: React.PropTypes.object,
        id: React.PropTypes.number,
        likes_count: React.PropTypes.number,
        price: React.PropTypes.string,
        value: React.PropTypes.string,
        liked: React.PropTypes.bool,
        images: React.PropTypes.object
      }),
      profilePhoto: React.PropTypes.string,
      time: React.PropTypes.number,
      type: React.PropTypes.string,
      user_id: React.PropTypes.number
    }),
    showAuthor: React.PropTypes.bool,
    isOwnerMessage: React.PropTypes.bool,
    handleLikeDress: React.PropTypes.func,
    changeDressToAddToCartCallback: React.PropTypes.func
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

  addToCart: function(){
    this.props.changeDressToAddToCartCallback(this.props.message.content.id);
    if($(window).width() < 768){
      $('#events__moodboard .mobile-select-size-modal .js-select-size-modal').show();
    }else{
      $('#events__moodboard .right-content .js-select-size-modal').show();
    }
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
    var dressImage = dress.images && dress.images.front.thumbnail.grey;
    var dressPositionStyle = (this.props.isOwnerMessage ? ' pull-right ' : ' pull-left ');

    return (
      <div className="msg msg-dress clearfix">
        <div className="container-fluid">
          <div className="row">
            <div className={'chat-dress-container col-xs-12' + dressPositionStyle}>

              {this.props.showAuthor ? this.getMessageData() : ''}

              <div className="chat-dress-right-col">
                <div className="chat-likes-container">
                  <div className="likes">
                    <span className={loveClass} onClick={this.handleLoveIt}></span>
                    <span>({dress.likes_count})</span>
                  </div>
                </div>
              </div>

              <div className="dress-box" key={dress.id}>
                <div className="dress-box-body text-center">
                  <img className="center-block" src={dressImage}/>
                  <div className="dress-info center-block">
                    <strong>The {dress.title}</strong>
                    <span>|</span>
                    <span>{dress.price}</span>
                  </div>
                </div>
                <div className="dress-box-footer">
                  <div className="center-block">
                    <button className="btn-add-to-cart" onClick={this.addToCart}>
                      Add to cart
                    </button>
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
