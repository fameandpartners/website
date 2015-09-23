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
      this.setState({blogs: result.posts.slice(0,9)})
    }.bind(this));
  },
  render: function() {
    if (this.state.blogs.length == 0){
      return (
        <div></div>
      );
    } else {

      post_0 = (<Post post={this.state.blogs[0]} />)
      post_1 = (<Post post={this.state.blogs[5]} />)
      post_2 = (<Post post={this.state.blogs[8]} />)
      post_3 = (<Post post={this.state.blogs[7]} />)
      post_4 = (<Post post={this.state.blogs[6]} />)
      post_5 = (<Post post={this.state.blogs[1]} />)
      post_6 = (<Post post={this.state.blogs[3]} />)
      post_7 = (<Post post={this.state.blogs[4]} />)
      return(
        <div className="blog-posts">

          <div className="logo-wrap">
            <img alt="Logo-theclique" src="/assets/logo/logo-theclique.png"></img>
          </div>

          <div className="posts">

            <div className="col">
              {post_0}
              {post_1}
              {post_2}
              {post_3}
            </div>

            <div className="col">
              {post_4}
              {post_5}
              {post_6}
              {post_7}
            </div>

          </div>

          <a className="btn btn-block btn-black btn-md" href="http://blog.fameandpartners.com">READ MORE...</a>
        </div>
      )
    }
  }

});
