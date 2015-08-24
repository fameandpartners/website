// Render the Zopim Launcher and the local support telephone number.
var SupportOptions = React.createClass({

  launchChatWindow: function(){
    // Just wrapping the Zopim global fn's for funzies here.
    $zopim.livechat.window.show();
  },

  render: function(){
    return (
        <ul className="list-inline">
          <li className="live-chat">
            <a onClick={this.launchChatWindow}>
              <i className="icon-live-chat" />
              Live Chat
            </a>
          </li>
          <li className="support-telephone">
            <i className="icon-support-telephone" />
            <a href={ "tel:" + this.props.support_telephone }>{ this.props.support_telephone }</a>
            </li>
        </ul>
    );
  }
});
