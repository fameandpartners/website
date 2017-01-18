var Help = React.createClass({

  componentDidMount: function () {
    this.handleBrowserResizing();
  },

  getInitialState: function () {
    return {
      showing: false
    }
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

    this.setState({showing: true});
  },

  hidePopovers: function () {
    $('#account-btn').popover('hide');
    $('#online-members-btn').popover('hide');
    $('#post-image-btn').popover('hide');
    $('#bridesmaid-dresses-tab').popover('hide');
    $('#wedding-details-tab').popover('hide');
    $('#manage-bridal-party-tab').popover('hide');

    this.setState({showing: false});
  },

  handleClose: function () {
    $(this.refs.fadeMe).hide();
    this.hidePopovers();
  },

  handleOpen: function() {
    $(this.refs.fadeMe).show();
    this.showPopovers();
  },

  render: function () {
    return (
      <div className="help-link">
        { this.state.showing ? <a className="btnClose icon-close-white" ref="btnClose" href="#" onClick={this.handleClose}></a> : ''}
        <div className="fadeMe" ref="fadeMe"></div>
        <a href="#" onClick={this.handleOpen}>
          <i className="help"></i>
        </a>
      </div>
    )
  }
});



  // componentDidMount: function () {
  //   window.test = $('#account_link');
  //   test.popover({
  //     template: '<div class="popover" role="tooltip"><div class="arrow"></div><h3 class="popover-title"></h3><div class="popover-content"></div></div>'
  //   });
  //   test.popover('show');
  // },
