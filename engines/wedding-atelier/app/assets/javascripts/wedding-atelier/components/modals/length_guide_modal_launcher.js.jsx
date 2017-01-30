var LenghtGuideModalLauncher = React.createClass({

  handleShowModal: function() {
    $('.js-lenght-guide-modal').modal();
  },

  render: function() {
    return (<a onClick={this.handleShowModal} href="#" className="guide-link hover-link">View size guide</a>);
  }
});
