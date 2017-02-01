var RemoveButton = React.createClass({
  propTypes: {
    clickCallback: React.PropTypes.func,
    active: React.PropTypes.bool
  },

  render: function(){
    var closeButtonClasses = classNames({
      'remove-button': true,
      small: true,
      absolute: true,
      active: this.props.active
    })
    return(<a href="#" className={closeButtonClasses} onClick={this.props.clickCallback} />)
  }
});
