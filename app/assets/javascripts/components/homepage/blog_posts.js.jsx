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
    return {blogs: []}
  },
  componentDidMount: function() {
    $.get("http://blog.fameandpartners.com/?json=1", function(result) {

      // Pushing the blogs which will be display on homepage
      blogs = [];
      for (i=0;i< result.posts.length;i++){
        if (result.posts[i].custom_fields.home_page_display == "true"){
          blogs.push(result.posts[i]);
        }
      }
      // Bubble sort those blogs by display order
      for (i=0;i< blogs.length-1;i++){
        for (j=i+1;j< blogs.length;j++){
          if (parseInt(blogs[i].custom_fields.home_page_display_order) > parseInt(blogs[j].custom_fields.home_page_display_order)) {
            temp = blogs[i];
            blogs[i] = blogs[j];
            blogs[j] = temp;
          }
        }
      }

      //Only display first 8 blogs
      blogs = blogs.slice(0,9);
      this.setState({blogs: blogs})
    }.bind(this));
  },
  render: function() {
    if (this.state.blogs.length == 0){
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
              <Post post={this.state.blogs[0]} />
              <Post post={this.state.blogs[1]} />
              <Post post={this.state.blogs[2]} />
              <Post post={this.state.blogs[3]} />
            </div>

            <div className="col">
              <Post post={this.state.blogs[4]} />
              <Post post={this.state.blogs[5]} />
              <Post post={this.state.blogs[6]} />
              <Post post={this.state.blogs[7]} />
            </div>

          </div>

          <a className="btn btn-block btn-black btn-md" href="http://blog.fameandpartners.com">READ MORE...</a>
        </div>
      )
    }
  }

});
