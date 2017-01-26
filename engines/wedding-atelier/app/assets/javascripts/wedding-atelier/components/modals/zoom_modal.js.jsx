var ZoomModal = React.createClass({
  propTypes: {
      images: React.PropTypes.array.isRequired,
      thumbnails: React.PropTypes.array.isRequired,
      selectedImageIndex: React.PropTypes.number.isRequired,
      visible: React.PropTypes.bool.isRequired,
      zoomClosedHandle: React.PropTypes.func.isRequired,
      thumbnailSelectedHandle: React.PropTypes.func.isRequired,
      imageNotFoundHandle: React.PropTypes.func.isRequired,
      isCustomDress: React.PropTypes.bool
  },

  getInitialState: function () {
    return {
      loading: true
    }
  },

  componentWillMount: function () {
    var that = this;
    $(this.refs.zoomModal).imagesLoaded({background: true}).always(function (instance) {
      that.setState({loading: false});
    });
  },

  renderThumbnails: function (selectedIndex) {
    var that = this;
    var thumbnails = this.props.thumbnails.map(function (image, index) {
      var classes = classNames({
        'zoom-modal-thumbnails-item': true,
        'selected': index === selectedIndex
      });
      var key = 'zoom-modal-thumb' + index;

      return (
        <li key={key} className={classes} onClick={that.props.thumbnailSelectedHandle.bind(null, index)}>
          <img src={image} onError={that.props.imageNotFoundHandle}/>
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
    var index = this.props.selectedImageIndex;
    if(this.props.selectedImageIndex > this.props.images.length){ index = 0; }

    return (
      <div ref="zoomModal" className="zoom-modal" style={{display: this.props.visible? 'block':'none'}}>
        <div className="close-zoom" onClick={this.props.zoomClosedHandle}></div>
        <div className="zoom-modal-image" ref="activeZoom">
          <img src={this.props.images[index]} style={{visibility: this.state.loading? 'hidden':'visible'}} onError={this.props.imageNotFoundHandle}/>
          <ImageLoader loading={this.state.loading} />
        </div>
        <div className="zoom-modal-pagination">
          {this.renderThumbnails(index)}
        </div>
    </div>
    );
  }
});
