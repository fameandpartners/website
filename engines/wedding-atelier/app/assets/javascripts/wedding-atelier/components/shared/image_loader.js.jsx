var ImageLoader = React.createClass({
  propTypes: {
    loading: React.PropTypes.bool.isRequired
  },

  render: function() {
    return (
      <div className="image-loader" style={{display: this.props.loading? 'block':'none'}}></div>
    );
  }
});
