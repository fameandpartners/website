var Post = React.createClass({
  render: function(){
    return(
      <a className={this.props.post.custom_fields.home_page_image_compact == "true" ? "post compact" : "post"} href={this.props.post.url}>
        <div className="media-wrap is-loaded">
          <div className="inner-wrap">
            <img alt="Blog image" src={this.props.post.custom_fields.home_page_image_url}></img>
          </div>
        </div>
        <div className="content-wrap">
          <h5 className="title txt-truncate-1">
            {this.props.post.custom_fields.home_page_image_title}
          </h5>
          <p className="txt-truncate-block">
            {this.props.post.custom_fields.home_page_image_text}
          </p>
        </div>
      </a>
    )
  }
});

var BlogPosts = React.createClass({
  getInitialState: function() {
    return {posts: []}
  },
  componentDidMount: function() {
    $.get("http://blog.fameandpartners.com/?json=1&count=100", function(result) {

      // Pushing the posts which will be display on homepage
      posts = [];
      for (i=0;i< result.posts.length;i++){
        if (result.posts[i].custom_fields.home_page_display == "true"){
          posts.push(result.posts[i]);
        }
      }

      //Sort those posts by display order
      posts.sort(function(a,b){
        return parseInt(a.custom_fields.home_page_display_order) - parseInt(b.custom_fields.home_page_display_order);
      });

      //Only display first 8 posts
      posts = posts.slice(0,9);
      this.setState({posts: posts})
    }.bind(this));
  },
  render: function() {
    if (this.state.posts.length == 0){
      return (
        <div></div>
      );
    } else {
      return(
        <div className="blog-posts">

          <div className="logo-wrap">
            <img alt="Logo-theclique" src="/assets/logo/logo-theclique.png"></img>
          </div>

          <div className="posts">

            <div className="col">
              <Post post={this.state.posts[0]} />
              <Post post={this.state.posts[1]} />
              <Post post={this.state.posts[2]} />
              <Post post={this.state.posts[3]} />
            </div>

            <div className="col">
              <Post post={this.state.posts[4]} />
              <Post post={this.state.posts[5]} />
              <Post post={this.state.posts[6]} />
              <Post post={this.state.posts[7]} />
            </div>

          </div>

          <a className="btn btn-block btn-black btn-md" href="http://blog.fameandpartners.com">READ MORE...</a>
        </div>
      )
    }
  }

});
