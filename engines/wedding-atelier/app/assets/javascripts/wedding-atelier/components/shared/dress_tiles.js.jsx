var DressTiles = React.createClass({

  propTypes: {
    dresses: React.PropTypes.array
  },

  render: function() {
    var content = this.props.dresses.map(function(dress) {
      return(<DressTile dress={dress} />)
    });
    return(<div className='dress-boxes'> {content} </div>)
  }
})
