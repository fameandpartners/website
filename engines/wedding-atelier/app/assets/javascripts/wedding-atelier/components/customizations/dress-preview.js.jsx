var DressPreview = React.createClass({
  propTypes: {
    selectedOptions: React.PropTypes.object,
    images: React.PropTypes.array.isRequired
  },

  getInitialState: function () {
    return {
      selectedImageIndex: 0,
      zoom: false
    };
  },

  thumbnailSelectedHandle: function (index) {
    this.setState({selectedImageIndex: index});
  },

  zoomClickedHandle: function () {
    this.setState({zoom: true});
  },

  zoomClosedHandle: function () {
    this.setState({zoom: false});
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
      <div className="dress-preview">
        <div className="preview">
          <img src={previewImage.url}/>
        </div>
        <div className="dress-preview-controls">
          <div className="dress-preview-zoom-in" onClick={this.zoomClickedHandle}></div>
          <div className="dress-preview-reset">
            <a href="#">Reset</a>
          </div>
          <div className="dress-preview-details">
            <a href="#">Details</a>
          </div>
        </div>
        <div className="dress-preview-pagination">
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
