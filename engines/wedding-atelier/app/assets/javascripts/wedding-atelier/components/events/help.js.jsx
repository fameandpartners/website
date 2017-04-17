var Help = React.createClass({

  getInitialState: function(){
    return {
      show: false
    }
  },

  showPopovers: function() {
    $('.walkthrough-messages').qtip({
        show: false,
        hide: false,
        events: {
          show: function(e, api){
            var $el = $(api.elements.target[0]);
            console.log($el);
            $el.qtip('option', 'position.my', $el.data('tooltip-my-position') || 'right center');
            $el.qtip('option', 'position.at', $el.data('tooltip-at-position') || 'left center');
            $el.qtip('option', 'content.text', $el.data('tooltip-content') || $el.attr('title'));
            $el.qtip('option', 'content.title', $el.attr('title'));
          }
        }
    }).qtip('show');
    $('.moodboard-tabs .tabs-container').addClass('show-popovers');
  },

  hidePopovers: function() {
    $('.walkthrough-messages').qtip('hide');
    $('.moodboard-tabs .tabs-container').removeClass('show-popovers');
  },

  handleClose: function(e) {
    this.hidePopovers();
    this.setState({show: false});
  },

  handleOpen: function() {
    this.showPopovers();
    this.setState({show: true});
  },

  render: function () {
    var fade, close;
    if(this.state.show){
      fade = <div className="fade-me" ref="fadeMe"></div>;
      close = <a className="btnClose icon-close-white" ref="btnClose" href="#" onClick={this.handleClose}></a>;
    }

    return (
      <div className="help-container hidden-xs">
        {fade}
        <div className="commands-help" onClick={this.handleOpen}></div>
        {close}
      </div>
    );
  }
});
