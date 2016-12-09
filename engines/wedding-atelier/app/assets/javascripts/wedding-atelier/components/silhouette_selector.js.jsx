var SilhouetteSelector = React.createClass({
  propTypes: {},

  close: function(){
    $(this.refs.container).hide();
  },

  select: function(dress){
    this.props.selectCallback('silhouette', dress);
  },

  render: function(){
    var dresses = this.props.dresses.map(function(dress){
      return (
        <div key={dress} onClick={this.select.bind(this, dress)} className="dress col-md-4">
          <p>{dress}</p>
        </div>
      )
    }.bind(this))

    return(
      <div ref="container" className="customization-selector silhouette animated slideInLeft">
        <div className="inner-header">
          <span className="close" onClick={this.close}>x</span>
        </div>
        <div>
          <p>Choose your perfect shape</p>
          <p>some more text aposkdapodskaopdsakopd</p>
        </div>
        <div className="dress-grid row">
          { dresses }
        </div>
      </div>
    )
  }
})
