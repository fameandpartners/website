var CustomizeSilhouette = React.createClass({
  propTypes: {
    selectCallback: React.PropTypes.func,
    dresses: React.PropTypes.array
  },

  close: function() {
    $(this.refs.container).hide();
  },

  select: function(dress) {
    this.props.selectCallback(this.props.componentName, dress);
  },

  render: function() {
    var dresses = this.props.dresses.map(function(dress, index) {
      return (
        <div key= {index } onClick={ this.select.bind(this, dress) } className="dress col-md-4">
          <p>{ dress }</p>
        </div>
      );
    }.bind(this));

    return (
      <div className="silhouette">
        <div>
          <p><em>Choose</em> your perfect shape</p>
          <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
        </div>
        <div className="dress-grid row">
          { dresses }
        </div>
     </div>

    );
  }
});
