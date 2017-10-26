/* eslint-disable */
// var ComponentCommentsModal = React.createClass({
//   handleClick: function(e) {
//     $(this.refs.payload.getDOMNode()).modal();
//   },
//   render: function() {
//     var numOfComments = this.props.assets.length;
//
//     return (
//       <div onClick={this.handleClick}>
//         <CommentsTrigger count={numOfComments} />
//         <CommentsModal ref='payload' {...this.props} />
//       </div>
//     );
//   },
// });
//
// var CommentsTrigger = React.createClass({
//   render: function() {
//     return (
//       <a href='javascript:;' className='comments-trigger'>COMMENTS ({this.props.count})</a>
//     );
//   }
// });
//
// var ModalComment = React.createClass({
//   render: function() {
//     if (this.props.currentUserId === this.props.moodboard_item_comment.user_id) {
//       return (
//         <div className='comment-wrap'>
//           <div className='user-name txt-truncate-1'>{this.props.moodboard_item_comment.first_name}</div>
//           <form
//             action={'/moodboard_item_comments/' + this.props.moodboard_item_comment.id}
//             id={'edit_moodboard_item_comment_' + this.props.moodboard_item_comment.id}
//             method='post'>
//             <input type='hidden' value='put' name='_method' />
//             <input type='hidden' value={this.props.token} name='authenticity_token' />
//             <div className='user-comment'>
//               <textarea
//                 id='moodboard_item_comment_comment'
//                 name='moodboard_item_comment[comment]'
//                 defaultValue={this.props.moodboard_item_comment.comment} />
//             </div>
//             <div className='toolbar'>
//               <input type='submit' value='update' className='btn btn-black' />
//               <a
//                 href={'/moodboard_item_comments/' + this.props.moodboard_item_comment.id}
//                 data-method='delete' rel='nofollow'>delete</a>
//             </div>
//           </form>
//         </div>
//       );
//     } else {
//       return (
//         <div className='comment-wrap'>
//           <div className='user-name txt-truncate-1'>{this.props.moodboard_item_comment.first_name}</div>
//           <div className='user-comment'>
//             <p>{this.props.moodboard_item_comment.comment}</p>
//           </div>
//           {toolbar}
//         </div>
//       );
//     }
//   }
// });
//
// var CommentsModal = React.createClass({
//   componentDidMount: function() {
//     $(this.getDOMNode()).modal({background: true, keyboard: true, show: false});
//   },
//   componentWillUnmount: function() {
//     $(this.getDOMNode()).off('hidden');
//   },
//   handleClick: function(e) {
//     e.stopPropagation();
//   },
//   render: function() {
//     var comments;
//
//     if(this.props.assets.length > 0) {
//       var currentUserId = this.props.currentUserId;
//       var token = this.props.token;
//       comments = this.props.assets.map(function(prop) {
//         return (
//           <ModalComment
//             key={'comment-list-' + prop.moodboard_item_comment.id}
//             {...prop}
//             currentUserId={currentUserId}
//             token={token} />
//         );
//       });
//     } else {
//       comments = 'Be the first to comment on this dress!';
//     }
//
//     return (
//       <div onClick={this.handleClick} className='modal fade' role='dialog' aria-hidden='true'>
//         <div className='modal-dialog'>
//           <div className='modal-content'>
//
//             <div className='modal-header'>
//               <button type='button' className='close' data-dismiss='modal' aria-label='Close'>
//                 <span aria-hidden='true'>&times;</span>
//               </button>
//               <h4 className='modal-title title-line-on-sides'>
//                 <div className='inner-wrap'>Comments about {this.props.itemName}</div>
//               </h4>
//             </div>
//
//             <div className='modal-body'>{comments}</div>
//
//             <div className='modal-footer'>
//               <form action='/moodboard_item_comments' method='post' id='new_moodboard_item_comment'>
//                 <input type='hidden' value={this.props.token} name='authenticity_token' />
//                 <input type='hidden' value={this.props.itemId}
//                   name='moodboard_item_comment[moodboard_item_id]'
//                   id='moodboard_item_comment_moodboard_item_id' />
//                 <input type='hidden' value={this.props.currentUserId}
//                   name='moodboard_item_comment[user_id]'
//                   id='moodboard_item_comment_user_id' />
//                 <div className='form-group'>
//                   <label htmlFor='moodboard_item_comment_comment'>Add a new Comment</label>
//                   <textarea name='moodboard_item_comment[comment]'
//                     id='moodboard_item_comment_comment' className='form-control' rows='2'></textarea>
//                 </div>
//                 <input type='submit' value='Submit Comment' className='btn btn-black' />
//               </form>
//             </div>
//
//           </div>
//         </div>
//       </div>
//     );
//   }
// });
