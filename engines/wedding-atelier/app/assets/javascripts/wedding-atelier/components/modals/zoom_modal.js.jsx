var ZoomModal = React.createClass({
  propTypes: {
      images: React.PropTypes.array.isRequired,
      defaultImageUrl: React.PropTypes.string
  },

  getInitialState: function () {
    return {
      selectedImageIndex: this.props.images[0]
    };
  },

  thumbnailSelectedHandle: function (index) {
    this.setState({selectedImageIndex: index});
  },

  renderThumbnails: function () {
    var that = this;
    var thumbnails = this.props.images.map(function (image, index) {
      var classes = classNames({
        'zoom-modal-thumbnails-item': true,
        'selected': index === that.state.selectedImageIndex
      });
      var key = 'zoom-modal-thumb' + index;

      return (
        <li key={key} className={classes} onClick={that.thumbnailSelectedHandle.bind(null, index)}>
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
    var image = this.props.images[this.state.selectedImageIndex];

    return (
      <div id="zoom-modal">
        <div className="pagination">
          <div className="close"></div>
          {this.renderThumbnails()}
        </div>
        <div className="img">
          <img src={image ? image.url : this.props.defaultImageUrl} />
        </div>
    </div>
    );
  }
});
