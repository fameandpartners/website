var SizeGuideModalLauncher = React.createClass({

  handleShowSizeGuide: function() {
    $('.js-size-guide-modal').modal();
  },

  render: function() {
    return <a onClick={this.handleShowSizeGuide} href="#" className="guide-link hover-link">(view size guide)</a>;
  }

});
