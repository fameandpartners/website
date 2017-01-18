var Help = React.createClass({

  showPopovers: function() {
    $('.walkthrough-messages').popover('show');
  },

  hidePopovers: function() {
    $('.walkthrough-messages').popover('hide');
  },

  handleClose: function(e) {
    this.hidePopovers();
    $(this.refs.btnClose).hide();
    $(this.refs.fadeMe).hide();
  },

  handleOpen: function() {
    this.showPopovers();
    $(this.refs.btnClose).show();
    $(this.refs.fadeMe).show();
  },

  render: function () {
    return (
      <div className="help-container hidden-xs">
        <div className="fade-me" ref="fadeMe"></div>
        <div className="commands-help" onClick={this.handleOpen}></div>
        <a className="btnClose icon-close-white" ref="btnClose" href="#" onClick={this.handleClose}></a>
      </div>
    );
  }
});
