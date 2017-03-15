var DressTile = React.createClass({

  propTypes: {
    changeDressToAddToCartCallback: React.PropTypes.func,
    dress: React.PropTypes.shape({
      author: React.PropTypes.string,
      id: React.PropTypes.number,
      image: React.PropTypes.string,
      images: React.PropTypes.object,
      liked: React.PropTypes.bool,
      likes_count: React.PropTypes.number,
      price: React.PropTypes.string,
      title: React.PropTypes.string
    }),
    dressesPath: React.PropTypes.string,
    handleLikeDress: React.PropTypes.func,
    index: React.PropTypes.number,
    removeDress: React.PropTypes.func,
    sendDressToChatFn: React.PropTypes.func
  },

  getInitialState: function(){
    return {
      loveClass: 'icon-unliked',
      sent: false
    };
  },

  handleLoveIt: function() {
    this.props.handleLikeDress(this.props.dress);
  },

  removeDress: function() {
    this.props.removeDress(this.props.dress);
  },

  sendToChatHandler: function() {
    this.props.sendDressToChatFn(this.props.dress);
    this.setState({sent: true});
  },

  editDressUrl: function() {
    return this.props.dressesPath + '/' + this.props.dress.id + '/edit';
  },

  addToCart: function() {
    this.props.changeDressToAddToCartCallback(this.props.dress);
    $('#events__moodboard .js-select-size-modal').show();
  },

  renderSend: function () {
    if (this.state.sent) {
      return (
        <span className="sent-to-chat"><i className="icon-tick"></i> Added to the group</span>
      );
    } else {
      return (
        <button className="btn-send-to-chat" onClick={this.sendToChatHandler}>
          Send to the group
        </button>
      );
    }
  },

  render: function () {
    var loveClass = this.props.dress.liked ? 'icon-liked' : 'icon-unliked',
        addedBy = 'Added by ' + this.props.dress.author;

    return (
        <div className="dress-box" key={this.props.dress.id}>
          <div className="top-info">
            <span>{addedBy}</span>
          </div>
          <div className="dress-box-header">
            <div className="likes">
              <span className={loveClass} onClick={this.handleLoveIt}></span> {this.props.dress.likes_count}
            </div>
            <a href="#" onClick={this.removeDress} className="icon-close pull-right"></a>
          </div>
          <a href={this.editDressUrl()} className="dress-box-body text-center">
            <img className="center-block" src={this.props.dress.images.front.thumbnail.grey}/>

            <div className="dress-info center-block">
              <strong>The {this.props.dress.title}</strong>
              <span>|</span>
              <span>{this.props.dress.price}</span>
            </div>
          </a>

          <div className="dress-box-footer center-block text-center">
            {this.renderSend()}
            <button className="btn-add-to-cart" onClick={this.addToCart}>
              Add to cart
            </button>
          </div>
        </div>
    );
  }
});
