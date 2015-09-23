var Post = React.createClass({
  render: function(){
    function fixQuote(text){
      return text.replace(/&#8217;/g,"'");
    };

    return(
      <a className={this.props.compact === "true" ? "post compact" : "post"} href={this.props.post.url}>
        <div className="media-wrap is-loaded">
          <div className="inner-wrap">
            <img alt="Blog image" src={this.props.img_url}></img>
          </div>
        </div>
        <div className="content-wrap">
          <h5 className="title txt-truncate-1">
            {this.props.title != null ? this.props.title : fixQuote(this.props.post.title)}
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

      post_0 = (<Post post={this.state.blogs[0]} des="We chat style with the NY fashionista" img_url={this.state.blogs[0].attachments[1].url}/>)
      post_1 = (<Post post={this.state.blogs[5]} compact="true" title="Follow Friday @flura_" des="We're obsessed with this florist's Instagram feed" img_url={this.state.blogs[5].attachments[1].url} />)
      post_2 = (<Post post={this.state.blogs[8]} des="Fashion's new favourite shade" img_url={this.state.blogs[8].attachments[1].url}/>)
      post_3 = (<Post post={this.state.blogs[7]} des="This weeks old school style muse" img_url={this.state.blogs[7].attachments[0].url}/>)
      post_4 = (<Post post={this.state.blogs[6]} des="Our campaign star spills on how she does formal chic" img_url="/assets/homepage/blog/blog-4.jpg"/>)
      post_5 = (<Post post={this.state.blogs[1]} des="That’s a Maxi Black Dress, people" img_url={this.state.blogs[1].attachments[14].url}/>)
      post_6 = (<Post post={this.state.blogs[3]} compact="true" des="It's her job to know what you want before you do." img_url={this.state.blogs[3].attachments[0].url}/>)
      post_7 = (<Post post={this.state.blogs[4]} des="Because sometimes it's okay to outshine the bride" img_url={this.state.blogs[4].attachments[0].url}/>)
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
