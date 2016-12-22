var DressTile = React.createClass({

  propTypes: {
    dress: React.PropTypes.shape({
      id: React.PropTypes.number,
      title: React.PropTypes.string,
      image: React.PropTypes.string,
      author: React.PropTypes.string,
      price: React.PropTypes.string
    })
  },



  getInitialState: function(){
    return {loveClass: 'icon-unliked'}
  },

  handleLoveIt: function() {
    this.setState({loveClass: 'icon-liked'})
  },

  render: function () {
    var loveClass = 'icon-liked';
    return (
        <div className="dress-box" key={this.props.dress.id}>
          <div className="top-info">
            <span>{this.props.dress.title}</span>
          </div>
          <div className="dress-box-header">
            <div className="likes">
              <span className={this.state.loveClass} onClick={this.handleLoveIt}></span> {this.props.dress.loveCount}
            </div>
            <a href="#" className="icon-close pull-right"></a>
          </div>
          <div className="dress-box-body text-center">
            <img className="center-block" src={this.props.dress.image}/>

            <div className="dress-info center-block">
              <strong>{this.props.dress.author}</strong>
              <span>|</span>
              <span>{this.props.dress.price}</span>
            </div>
          </div>

          <div className="dress-box-footer center-block">
            <button className="btn-send-to-chat">
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
