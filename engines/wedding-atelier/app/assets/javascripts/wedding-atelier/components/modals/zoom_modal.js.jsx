var ZoomModal = React.createClass({
  propTypes: {
      images: React.PropTypes.array.isRequired,
      defaultImageUrl: React.PropTypes.string,
      selectedImageIndex: React.PropTypes.number.isRequired,
      visible: React.PropTypes.bool.isRequired,
      zoomClosedHandle: React.PropTypes.func.isRequired,
      thumbnailSelectedHandle: React.PropTypes.func.isRequired
  },

  renderThumbnails: function () {
    var that = this;
    var thumbnails = this.props.images.map(function (image, index) {
      var classes = classNames({
        'zoom-modal-thumbnails-item': true,
        'selected': index === that.props.selectedImageIndex
      });
      var key = 'zoom-modal-thumb' + index;

      return (
        <li key={key} className={classes} onClick={that.props.thumbnailSelectedHandle.bind(null, index)}>
          <img src={image.thumbnailUrl} />
        </li>
      );
    });

    return (
      <ul className="zoom-modal-thumbnails">
        {thumbnails}
      </ul>
    );
  },

  render: function() {
    var image = this.props.images[this.props.selectedImageIndex];

    return (
      <div ref="zoomModal" className="zoom-modal" style={{display: this.props.visible? 'block':'none'}}>
        <div className="close-zoom" onClick={this.props.zoomClosedHandle}></div>
        <div className="zoom-modal-image">
          <img src={image ? image.url : this.props.defaultImageUrl} />
        </div>
        <div className="zoom-modal-pagination">
          {this.renderThumbnails()}
        </div>
    </div>
    );
  }
});
