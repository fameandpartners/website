var Dress = React.createClass({
  propTypes: {
    name: React.PropTypes.string,
    style: React.PropTypes.string
  },

  render: function() {
    return (
      <div>
        <div>Name: {this.props.name}</div>
        <div>Style: {this.props.style}</div>
      </div>
    );
  }
});
