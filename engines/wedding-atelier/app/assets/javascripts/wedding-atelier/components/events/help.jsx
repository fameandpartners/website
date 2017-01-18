var Help = React.createClass({
  componentDidMount: function () {
    this.handleBrowserResizing();
    $(document).ready(this.showPopovers);
  },

  handleBrowserResizing: function () {
    $(window).resize(function(e) {
      if (this.state.showing) {
        this.showPopovers();
      }
    }.bind(this));
  },

  showPopovers: function () {
    $('#account-btn').popover('show');
    $('#online-members-btn').popover('show');
    $('#post-image-btn').popover('show');
    $('#bridesmaid-dresses-tab').popover('show');
    $('#wedding-details-tab').popover('show');
    $('#manage-bridal-party-tab').popover('show');
  },

  hidePopovers: function () {
    $('#account-btn').popover('hide');
    $('#online-members-btn').popover('hide');
    $('#post-image-btn').popover('hide');
    $('#bridesmaid-dresses-tab').popover('hide');
    $('#wedding-details-tab').popover('hide');
    $('#manage-bridal-party-tab').popover('hide');
  },

  handleClose: function () {
    this.hidePopovers();
    ReactDOM.unmountComponentAtNode(document.getElementById('notification'));
  },

  render: function () {
    return (
      <div className="help-container">
         <a className="btnClose icon-close-white" ref="btnClose" href="#" onClick={this.handleClose}></a>
         <div className="fade-me" ref="fadeMe"></div>
      </div>
    );
  }
});
