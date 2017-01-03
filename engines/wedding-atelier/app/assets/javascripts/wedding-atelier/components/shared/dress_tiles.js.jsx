var DressTiles = React.createClass({

  propTypes: {
    sendDressToChatFn: React.PropTypes.func,
    dresses: React.PropTypes.array
  },

  render: function() {
    var content = this.props.dresses.map(function(dress) {
      return(<DressTile key={'dress-tile-' + dress.id} dress={dress} sendDressToChatFn={this.props.sendDressToChatFn} />)
    }.bind(this));
    return(<div className='dress-boxes'> {content} </div>)
  }
})
