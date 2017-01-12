var DressTile = React.createClass({

  propTypes: {
    sendDressToChatFn: React.PropTypes.func,
    handleLikeDress: React.PropTypes.func,
    index: React.PropTypes.number,
    dress: React.PropTypes.shape({
      id: React.PropTypes.number,
      title: React.PropTypes.string,
      image: React.PropTypes.string,
      author: React.PropTypes.string,
      price: React.PropTypes.string,
      likes_count: React.PropTypes.number,
      liked: React.PropTypes.bool,
      images: React.PropTypes.array
    })
  },

  getInitialState: function(){
    return {loveClass: 'icon-unliked'}
  },

  handleLoveIt: function() {
    this.props.handleLikeDress(this.props.dress);
  },

  sendToChatHandler: function() {
    this.props.sendDressToChatFn(this.props.dress);
  },

  render: function () {
    var loveClass = this.props.dress.liked ? 'icon-liked' : 'icon-unliked';

    return (
        <div className="dress-box" key={this.props.dress.id}>
          <div className="top-info">
            <span>{this.props.dress.title}</span>
          </div>
          <div className="dress-box-header">
            <div className="likes">
              <span className={loveClass} onClick={this.handleLoveIt}></span> {this.props.dress.likes_count}
            </div>
            <a href="#" className="icon-close pull-right"></a>
          </div>
          <div className="dress-box-body text-center">
            <img className="center-block" src={this.props.dress.images[0].moodboard}/>

            <div className="dress-info center-block">
              <strong>{this.props.dress.author}</strong>
              <span>|</span>
              <span>{this.props.dress.price}</span>
            </div>
          </div>

          <div className="dress-box-footer center-block text-center">
            <button className="btn-send-to-chat" onClick={this.sendToChatHandler}>
              Send to chat
            </button>
            <button className="btn-add-to-cart">
              Add to cart
            </button>
          </div>
        </div>
    );
  }
});
