var DressTile = React.createClass({

  propTypes: {
    sendDressToChatFn: React.PropTypes.func,
    handleLikeDress: React.PropTypes.func,
    removeDress: React.PropTypes.func,
    index: React.PropTypes.number,
    dressesPath: React.PropTypes.string,
    dress: React.PropTypes.shape({
      id: React.PropTypes.number,
      title: React.PropTypes.string,
      image: React.PropTypes.string,
      author: React.PropTypes.string,
      price: React.PropTypes.string,
      likes_count: React.PropTypes.number,
      liked: React.PropTypes.bool,
      images: React.PropTypes.object
    }),
    changeDressToAddToCartCallback: React.PropTypes.func
  },

  getInitialState: function(){
    return {loveClass: 'icon-unliked'}
  },

  handleLoveIt: function() {
    this.props.handleLikeDress(this.props.dress);
  },

  removeDress: function(){
    this.props.removeDress(this.props.dress)
  },

  sendToChatHandler: function() {
    this.props.sendDressToChatFn(this.props.dress);
  },

  editDressUrl: function(){
    return this.props.dressesPath + '/' + this.props.dress.id + '/edit';
  },

  addToCart: function(){
    this.props.changeDressToAddToCartCallback(this.props.dress.id);
    if($(window).width() < 768){
      $('#events__moodboard .mobile-select-size-modal .js-select-size-modal').show();
    }else{
      $('#events__moodboard .right-content .js-select-size-modal').show();
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
            <button className="btn-send-to-chat" onClick={this.sendToChatHandler}>
              Send to the group
            </button>
            <button className="btn-add-to-cart" onClick={this.addToCart}>
              Add to cart
            </button>
          </div>
        </div>
    );
  }
});
