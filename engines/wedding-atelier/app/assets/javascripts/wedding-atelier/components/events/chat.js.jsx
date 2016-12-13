var Chat = React.createClass({
  render: function() {
    return(
      <div className="chat-container">
        <div className="chat-general-info center-block">
          <div className="chat-header-left-side pull-left">
            <strong>Who's online</strong>:Janine, Tania, <s className="text-muted">Nyreee</s>, <s className="text-muted">Kate</s>
          </div>
          <div className="chat-header-right-side pull-right">
            <strong>Fame stylist online: </strong><span className="stylist-name">Amber: </span><img src="http://localhost:3000/assets/profile-placeholder.jpg" className="stylist-photo" />
          </div>
        </div>
        <div className="chat-log">
          <div className="msg-simple">
            <div className="msg-data">
              <div className="profile">
                <img className="photo" src="http://localhost:3000/assets/profile-placeholder.jpg" /><span className="name">Amber@fame</span><span className="created pull-right">today, 2:22pm</span>
              </div>
            </div>
            <div className="msg-text">
              Hey lovely, welcome to your amazing new weddings board. Hereyou're going to be able to chat with me, your bridesmadis and&nbsp;create some stunning bridal looks.
            </div>
          </div>
          <div className="msg-simple">
            <div className="msg-data">
              <div className="profile">
                <img className="photo" src="http://localhost:3000/assets/profile-placeholder.jpg" /><span className="name">Amber@fame</span><span className="created pull-right">today, 2:22pm</span>
              </div>
            </div>
            <div className="msg-text">
              Why don't you start by creating your first dress, just select"<strong>ADD YOUR FIRST DRESS</strong>" to the right.
            </div>
          </div>
          <div className="msg-simple">
            <div className="msg-data">
              <div className="profile">
                <img className="photo" src="http://localhost:3000/assets/profile-placeholder.jpg" /><span className="name">Amber@fame</span><span className="created pull-right">today, 2:22pm</span>
              </div>
            </div>
            <div className="msg-text">
              Test...
            </div>
          </div>
          <div className="msg-simple">
            <div className="msg-data">
              <div className="profile">
                <img className="photo" src="http://localhost:3000/assets/profile-placeholder.jpg" /><span className="name">Amber@fame</span><span className="created pull-right">today, 2:22pm</span>
              </div>
            </div>
            <div className="msg-text">
              Test...
            </div>
          </div>
          <div className="msg-simple">
            <div className="msg-data">
              <div className="profile">
                <img className="photo" src="http://localhost:3000/assets/profile-placeholder.jpg" /><span className="name">Amber@fame</span><span className="created pull-right">today, 2:22pm</span>
              </div>
            </div>
            <div className="msg-text">
              Test...
            </div>
          </div>
          <div className="msg-simple">
            <div className="msg-data">
              <div className="profile">
                <img className="photo" src="http://localhost:3000/assets/profile-placeholder.jpg" /><span className="name">Amber@fame</span>
              </div>
              <div className="created">
                today, 2:22pm
              </div>
            </div>
            <div className="msg-text">
              Test...
            </div>
          </div>
          <div className="msg-simple">
            <div className="msg-data">
              <div className="profile">
                <img className="photo" src="http://localhost:3000/assets/profile-placeholder.jpg" /><span className="name">Amber@fame</span><span className="created pull-right">today, 2:22pm</span>
              </div>
            </div>
            <div className="msg-text">
              Test...
            </div>
          </div>
          <div className="msg-simple">
            <div className="msg-data">
              <div className="profile">
                <img className="photo" src="http://localhost:3000/assets/profile-placeholder.jpg" /><span className="name">Amber@fame</span><span className="created pull-right">today, 2:22pm</span>
              </div>
            </div>
            <div className="msg-text">
              Test...
            </div>
          </div>
          <div className="msg-simple">
            <div className="msg-data">
              <div className="profile">
                <img className="photo" src="http://localhost:3000/assets/profile-placeholder.jpg" /><span className="name">Amber@fame</span><span className="created pull-right">today, 2:22pm</span>
              </div>
            </div>
            <div className="msg-text">
              Test...
            </div>
          </div>
          <div className="msg-simple">
            <div className="msg-data">
              <div className="profile">
                <img className="photo" src="http://localhost:3000/assets/profile-placeholder.jpg" /><span className="name">Amber@fame</span><span className="created pull-right">today, 2:22pm</span>
              </div>
            </div>
            <div className="msg-text">
              Test...
            </div>
          </div>
          <div className="msg-simple">
            <div className="msg-data">
              <div className="profile">
                <img className="photo" src="http://localhost:3000/assets/profile-placeholder.jpg" /><span className="name">Amber@fame</span><span className="created pull-right">today, 2:22pm</span>
              </div>
            </div>
            <div className="msg-text">
              Test...
            </div>
          </div>
          <div className="msg-simple">
            <div className="msg-data">
              <div className="profile">
                <img className="photo" src="http://localhost:3000/assets/profile-placeholder.jpg" /><span className="name">Amber@fame</span><span className="created pull-right">today, 2:22pm</span>
              </div>
            </div>
            <div className="msg-text">
              Test...
            </div>
          </div>
          <div className="msg-simple">
            <div className="msg-data">
              <div className="profile">
                <img className="photo" src="http://localhost:3000/assets/profile-placeholder.jpg" /><span className="name">Amber@fame</span><span className="created pull-right">today, 2:22pm</span>
              </div>
            </div>
            <div className="msg-text">
              This is what it looks like..
            </div>
          </div>
          <div className="msg-image">
            <div className="msg-data">
              <div className="profile">
                <img className="photo" src="http://localhost:3000/assets/profile-placeholder.jpg" /><span className="name">Amber@fame</span><span className="created pull-right">today, 2:22pm</span>
              </div>
            </div>
            <div className="attachment">
              <img src="uploadedimagsource" />
            </div>
          </div>
        </div>
        <div className="chat-actions">
          <button className="btn upload-image"></button>
          <div className="message-input">
            <input type="text" value="" />
          </div>
          <div className="btn-send-container">
            <button className="btn btn-black btn-send-to-chat">send</button>
          </div>
        </div>
      </div>
    )
  }
});
