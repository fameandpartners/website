var ChatDressMessage = React.createClass({

  propTypes: {
    message: React.PropTypes.object
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

  render: function() {
    var formattedDate = this.getTime();
    var dress = this.props.message.content;
    var loveClass = 'icon-liked';

    return (
      <div className="msg-dress">
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
    );
  }
});
