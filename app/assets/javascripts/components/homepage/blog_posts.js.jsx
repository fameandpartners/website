/* eslint-disable */
// var Post = React.createClass({
//   render: function(){
//     return(
//       <a className={this.props.post.custom_fields.home_page_image_compact == "true" ? "post compact" : "post"} href={this.props.post.url}>
//         <div className="media-wrap is-loaded">
//           <div className="inner-wrap">
//             <img alt="Blog image" src={this.props.post.custom_fields.home_page_image_url}></img>
//           </div>
//         </div>
//         <div className="content-wrap">
//           <h5 className="title txt-truncate-1">
//             {this.props.post.custom_fields.home_page_image_title}
//           </h5>
//           <p className="txt-truncate-block">
//             {this.props.post.custom_fields.home_page_image_text}
//           </p>
//         </div>
//       </a>
//     )
//   }
// });
//
// var BlogPosts = React.createClass({
//   getInitialState: function() {
//     return {posts: []}
//   },
//   componentDidMount: function() {
//     $.ajax({
//       url: "//blog.fameandpartners.com/api/get_recent_posts/",
//       method: "GET",
//       data: { count: "100" },
//       dataType: "jsonp",
//       success: function (result) {
//         var posts = (result.posts || [])
//             .filter(function (post) {
//               return post.custom_fields.home_page_display == "true"
//             })
//             .slice(0, 7)
//             .sort(function (post, another_post) {
//               // WP custom fields values seems to be an Array, so `home_page_display_order` returns something like: ["1"], ["2"], ...
//               return parseInt(post.custom_fields.home_page_display_order[0]) - parseInt(another_post.custom_fields.home_page_display_order[0])
//             });
//
//         this.setState({posts: posts})
//       }.bind(this)
//     });
//   },
//   render: function() {
//     if (this.state.posts.length == 0){
//       return (
//         <div></div>
//       );
//     } else {
//       return(
//         <div className="blog-posts">
//
//           <div className="logo-wrap">
//             <img alt="Logo-theclique" src="/assets/logo/logo-theclique.png"></img>
//           </div>
//
//           <div className="posts">
//
//             <div className="col">
//               <Post post={this.state.posts[0]} />
//               <Post post={this.state.posts[1]} />
//               <Post post={this.state.posts[2]} />
//             </div>
//
//             <div className="col">
//               <Post post={this.state.posts[3]} />
//               <Post post={this.state.posts[4]} />
//               <Post post={this.state.posts[5]} />
//             </div>
//
//           </div>
//
//           <a className="btn btn-block btn-black btn-md" href="http://blog.fameandpartners.com">READ MORE...</a>
//         </div>
//       )
//     }
//   }
//
// });
