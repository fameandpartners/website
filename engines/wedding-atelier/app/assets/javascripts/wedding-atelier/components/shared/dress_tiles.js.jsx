var DressTiles = React.createClass({

  propTypes: {
    sendDressToChatFn: React.PropTypes.func,
    dresses: React.PropTypes.array,
    handleLikeDress: React.PropTypes.func,
    removeDress: React.PropTypes.func,
    dressesPath: React.PropTypes.string,
    changeDressToAddToCartCallback: React.PropTypes.func
  },

  render: function() {
    var content = this.props.dresses.map(function(dress, i) {
      return(<DressTile key={'dress-tile-' + dress.id} dress={dress}
        sendDressToChatFn={this.props.sendDressToChatFn}
        handleLikeDress={this.props.handleLikeDress}
        removeDress={this.props.removeDress}
        dressesPath={this.props.dressesPath}
        changeDressToAddToCartCallback={this.props.changeDressToAddToCartCallback}
        index={i} />)
    }.bind(this));
    return(<div className='dress-boxes'> {content} </div>)
  }
})
