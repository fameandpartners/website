var ComponentCommentsModal = React.createClass({
  handleClick: function(e) {
    $(this.refs.payload.getDOMNode()).modal();
  },
  render: function() {
    var Trigger = this.props.trigger;
    var numOfComments = this.props.assets.length;

    return (<div onClick={this.handleClick}>
      <CommentsTrigger count={numOfComments} />
      <CommentsModal ref="payload" props={this.props}>
      </CommentsModal>
    </div>);
  },
});

var CommentsTrigger = React.createClass({
  render: function() {
    return (
      <a href='javascript:;' className='comments-trigger'>COMMENTS ({this.props.count})</a>
    );
  }
});

var ModalComment = React.createClass({
  render: function() {
    return (
      <div className='comment-wrap'>
        <div className='user-name'>{this.props.prop.moodboard_comment.user_id}</div>
        <div className='user-comment'>{this.props.prop.moodboard_comment.comment}</div>
      </div>
    );
  }
});
 
var CommentsModal = React.createClass({
  componentDidMount: function() {
    // Initialize the modal, once we have the DOM node
    // TODO: Pass these in via props
    $(this.getDOMNode()).modal({background: true, keyboard: true, show: false});
  },
  componentWillUnmount: function() {
    $(this.getDOMNode()).off('hidden');
  },
  // This was the key fix --- stop events from bubbling
  handleClick: function(e) {
    e.stopPropagation();
  },
  render: function() {
    console.log(this.props.props);
    var comments; 

    if(this.props.props.assets.length > 0) {
      comments = this.props.props.assets.map(function(prop) {
        return (<ModalComment key={'comment-list-' + prop.moodboard_comment.id} prop={prop} />);
      });
    } else {
      comments = this.props.props.assets.map(function(prop) {
        return (<p>Be the first to comment on this dress!</p>);
      });
    }

    return (
      <div onClick={this.handleClick} className='modal fade' role='dialog' aria-hidden='true'>
        <div className='modal-dialog'>
          <div className='modal-content'>

            <div className='modal-header'>
              <button type='button' className='close' data-dismiss='modal' aria-label='Close'>
                <span aria-hidden='true'>&times;</span>
              </button>
              <h4 className='modal-title'>Comments about {this.props.props.itemName}</h4>
            </div>

            <div className='modal-body'>{comments}</div>

            <div className='modal-footer'>
              <form action='/moodboard_comments' method='post' id='new_moodboard_comment'>
                <input type='hidden' value={this.props.props.token} name='authenticity_token' />
                <input type='hidden' value={this.props.props.itemId} name='moodboard_comment[moodboard_item_id]' id='moodboard_comment_moodboard_item_id' />
                <input type='hidden' value={this.props.props.userId} name="moodboard_comment[user_id]" id='moodboard_comment_user_id' />
                <div className="form-group">
                  <label for='moodboard_comment_comment'>Add a new Comment</label>
                  <textarea name="moodboard_comment[comment]" id='moodboard_comment_comment' className='form-control' rows='2'></textarea>
                </div>
                <input type='submit' value='Submit Comment' name='commit' className='btn btn-black' />
              </form>
            </div>

          </div>
        </div>
      </div>
    );
  }
});
