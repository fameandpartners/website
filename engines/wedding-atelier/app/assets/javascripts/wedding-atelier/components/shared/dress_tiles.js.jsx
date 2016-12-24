var DressTiles = React.createClass({

  propTypes: {
    dresses: React.PropTypes.array
  },

  getInitialState: function(){
    return {dresses: []}
  },

  componentDidMount: function(){
    this.setState({dresses: this.props.dresses})
  },

  render: function() {
    var content = this.state.dresses.map(function(dress) {
      return(<DressTile dress={dress} />)
    });
    return(<div className='dress-boxes'> {content} </div>)
  }
})
