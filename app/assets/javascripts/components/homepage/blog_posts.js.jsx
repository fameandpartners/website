var Post = React.createClass({
  render: function(){
    return(
      <a className={this.props.compact === "true" ? "post compact" : "post"} href={this.props.post.link}>
        <div className="media-wrap is-loaded">
          <div className="inner-wrap">
            <img alt="Blog image" src={this.props.img_url}></img>
          </div>
        </div>
        <div className="content-wrap">
          <h5 className="title txt-truncate-1">
            {this.props.post.title}
          </h5>
          <p className="txt-truncate-block">
            {this.props.des}
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
    $.get("/api/blog_posts", function(result) {1
      this.setState({blogs: result.slice(0,9)})
    }.bind(this));
  },
  render: function() {
    if (this.state.blogs.length == 0){
      return (
        <div></div>
      );
    } else {

      post_0 = (<Post post={this.state.blogs[0]} des="We chat style with the NY fashionista" img_url="/assets/homepage/blog/blog-1.jpg"/>)
      post_1 = (<Post post={this.state.blogs[5]} compact="true" des="We're obsessed with this florist's Instagram feed" img_url="assets/homepage/blog/blog-5.jpg"/>)
      post_2 = (<Post post={this.state.blogs[8]} des="Fashion's new favourite shade" img_url="/assets/homepage/blog/blog-2.jpg"/>)
      post_3 = (<Post post={this.state.blogs[7]} des="This weeks old school style muse" img_url="/assets/homepage/blog/blog-3.jpg"/>)
      post_4 = (<Post post={this.state.blogs[6]} des="Our campaign star spills on how she does formal chic" img_url="/assets/homepage/blog/blog-4.jpg"/>)
      post_5 = (<Post post={this.state.blogs[1]} des="That’s a Maxi Black Dress, people" img_url="/assets/homepage/blog/blog-7.jpg"/>)
      post_6 = (<Post post={this.state.blogs[3]} compact="true" des="It's her job to know what you want before you do." img_url="/assets/homepage/blog/blog-6.jpg"/>)
      post_7 = (<Post post={this.state.blogs[4]} des="Because sometimes it's okay to outshine the bride" img_url="/assets/homepage/blog/blog-8.jpg"/>)
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
