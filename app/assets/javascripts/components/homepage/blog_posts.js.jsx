var BlogPosts = React.createClass({
  getInitialState: function() {
    return {}
  },
  componentDidMount: function() {

  },
  render: function() {
    return(
      <div className="blog-posts">
        <div className="logo-wrap">
          <img alt="Logo-theclique" src="/assets/logo/logo-theclique.png"></img>

          <div className="posts">

            <div className="col">
              <a className="post" href="http://blog.fameandpartners.com/jessica-schiffer-fashion-features-editor-whowhatwear-nyc/">
                <div className="media-wrap is-loaded">
                  <div className="inner-wrap">
                    <img alt="Blog image" src="/assets/homepage/blog/blog-1.jpg"></img>
                  </div>
                </div>
                <div className="content-wrap">
                  <h5 className="title txt-truncate-1">
                    Jessica Schiffer, Fashion Features Editor, Who What Wear
                  </h5>
                  <p className="txt-truncate-block">
                    We chat style with the NY fashionista
                  </p>
                </div>
              </a>

              <a className="post compact" href="http://blog.fameandpartners.com/ff-_fjura">
                <div className="media-wrap is-loaded">
                  <div className="inner-wrap">
                    <img alt="Blog image" src="/assets/homepage/blog/blog-5.jpg"></img>
                  </div>
                </div>
                <div className="content-wrap">
                  <h5 className="title txt-truncate-1">
                    Follow Friday @flura_
                  </h5>
                  <p className="txt-truncate-block">
                    We're obsessed with this florist's Instagram feed
                  </p>
                </div>
              </a>

              <a className="post" href="http://blog.fameandpartners.com/at-first-blush">
                <div className="media-wrap is-loaded">
                  <div className="inner-wrap">
                    <img alt="Blog image" src="/assets/homepage/blog/blog-2.jpg"></img>
                  </div>
                </div>
                <div className="content-wrap">
                  <h5 className="title txt-truncate-1">
                    First Blush
                  </h5>
                  <p className="txt-truncate-block">
                    Fashions new favourite shade
                  </p>
                </div>
              </a>

              <a className="post" href="http://blog.fameandpartners.com/tbt-lauren-hutton-1975">
                <div className="media-wrap is-loaded">
                  <div className="inner-wrap">
                    <img alt="Blog image" src="/assets/homepage/blog/blog-3.jpg"></img>
                  </div>
                </div>
                <div className="content-wrap">
                  <h5 className="title txt-truncate-1">
                    #TBT Lauren Hutton, 1975
                  </h5>
                  <p className="txt-truncate-block">
                    This weeks old school style muse
                  </p>
                </div>
              </a>
            </div>

            <div className="col">
              <a className="post" href="http://blog.fameandpartners.com/bambis-guide-to-black-tie-beauty">
                <div className="media-wrap is-loaded">
                  <div className="inner-wrap">
                    <img alt="Blog image" src="/assets/homepage/blog/blog-4.jpg"></img>
                  </div>
                </div>
                <div className="content-wrap">
                  <h5 className="title txt-truncate-1">
                    Bambis Guide to Black Tie
                  </h5>
                  <p className="txt-truncate-block">
                    Our campaign star spills on how she does formal chic
                  </p>
                </div>
              </a>

              <a className="post" href="http://blog.fameandpartners.com/the-secret-to-styling-an-mbd-maxi-black-dress">
                <div className="media-wrap is-loaded">
                  <div className="inner-wrap">
                    <img alt="Blog image" src="/assets/homepage/blog/blog-7.jpg"></img>
                  </div>
                </div>
                <div className="content-wrap">
                  <h5 className="title txt-truncate-1">
                    The Secret To Styling An MBD
                  </h5>
                  <p className="txt-truncate-block">
                    That’s a Maxi Black Dress, people
                  </p>
                </div>
              </a>

              <a className="post compact" href="http://blog.fameandpartners.com/dannielle-cartisano-market-editor-elle-australia">
                <div className="media-wrap is-loaded">
                  <div className="inner-wrap">
                    <img alt="Blog image" src="/assets/homepage/blog/blog-6.jpg"></img>
                  </div>
                </div>
                <div className="content-wrap">
                  <h5 className="title txt-truncate-1">
                    Dannielle Cartisano, Market Editor, ELLE Australia
                  </h5>
                  <p className="txt-truncate-block">
                    Its her job to know what you want before you do.
                  </p>
                </div>
              </a>

              <a className="post" href="http://blog.fameandpartners.com/5-on-trend-dresses-youll-need-for-the-wedding-season">
                <div className="media-wrap is-loaded">
                  <div className="inner-wrap">
                    <img alt="Blog image" src="/assets/homepage/blog/blog-8.jpg"></img>
                  </div>
                </div>
                <div className="content-wrap">
                  <h5 className="title txt-truncate-1">
                    5 On-Trend Dresses Youll Need For The Wedding Season Ahead
                  </h5>
                  <p className="txt-truncate-block">
                    Because sometimes its okay to outshine the bride
                  </p>
                </div>
              </a>
            </div>

          </div>

        </div>
        <a className="btn btn-block btn-black btn-md" href="http://blog.fameandpartners.com">READ MORE...</a>
      </div>
    )
  }

});
