var DressPreview = React.createClass({
  propTypes: {
    selectedOptions: React.PropTypes.object,
    images: React.PropTypes.array.isRequired,
    onZoomInCallback: React.PropTypes.func,
    onZoomOutCallback: React.PropTypes.func
  },

  getInitialState: function () {
    return {
      selectedImageIndex: 0,
      zoom: false,
      loading: true,
      showDetails: false
    };
  },

  componentDidMount: function () {
    this.isLoading();
  },

  isLoading: function () {
    var that = this;
    $(this.refs.dressPreview).imagesLoaded({background: true}).done(function (instance) {
        that.setState({loading: false});
    });
  },

  thumbnailSelectedHandle: function (index) {
    this.isLoading();
    this.setState({selectedImageIndex: index, loading: true});
  },

  zoomClickedHandle: function () {
    if(this.props.onZoomInCallback) { this.props.onZoomInCallback(); }
    this.setState({zoom: true});
  },

  zoomClosedHandle: function () {
    if(this.props.onZoomOutCallback) { this.props.onZoomOutCallback(); }
    this.setState({zoom: false});
  },

  detailsShownHandle: function () {
    this.setState({showDetails: true});
  },

  detailsClosedHandle: function () {
    this.setState({showDetails: false});
  },

  renderThumbnails: function () {
    var that = this;
    var thumbnails = this.props.images.map(function (image, index) {
      var classes = classNames({
        'dress-preview-thumbnails-item': true,
        'selected': index === that.state.selectedImageIndex
      });
      var key = 'dress-preview-thumb' + index;

      return (
        <li key={key} className={classes} onClick={that.thumbnailSelectedHandle.bind(null, index)}>
          <img src={image.thumbnailUrl} />
        </li>
      );
    });

    return (
      <ul className="dress-preview-thumbnails">
        {thumbnails}
      </ul>
    );
  },

  render: function() {
    var previewImage = this.props.images[this.state.selectedImageIndex];

    return (
      <div ref="dressPreview" className="dress-preview">
        <div className="preview">
          <img src={previewImage.url} style={{visibility: this.state.loading? 'hidden' : 'visible'}}/>
          <ImageLoader loading={this.state.loading} />
        </div>
        <div className="dress-preview-controls">
          <div className="dress-preview-zoom-in" onClick={this.zoomClickedHandle}></div>
          <div className="hidden-xs">
            <a href="#"
              onClick={this.detailsShownHandle}
              style={{display: this.state.showDetails? 'none':'block'}}>
              Details
            </a>
            <div
              className="dress-preview-details"
              style={{display: this.state.showDetails? 'block':'none'}}>
              <div
                className="dress-preview-details-close" onClick={this.detailsClosedHandle}>
              </div>
              <div className="dress-preview-details-container">
                <p className="dress-preview-details-text-long">"The hand-draped, corseted bodice prefectly hugs curtves, acres of silk chiffon make a divinely floaty skirt"</p>
                <p className="dress-preview-details-text-short">For the girl with the free spirit</p>
              </div>
            </div>
          </div>
        </div>
        <div
          className="dress-preview-pagination"
          style={{display: this.state.showDetails? 'none':'block'}}>
          {this.renderThumbnails()}
        </div>
        <ZoomModal
          images={this.props.images}
          selectedImageIndex={this.state.selectedImageIndex}
          visible={this.state.zoom}
          zoomClosedHandle={this.zoomClosedHandle}
          thumbnailSelectedHandle={this.thumbnailSelectedHandle}/>
      </div>
    );
  }
});
