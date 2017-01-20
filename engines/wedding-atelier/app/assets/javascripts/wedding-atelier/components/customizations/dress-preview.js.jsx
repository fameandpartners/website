var DressPreview = React.createClass({
  propTypes: {
    selectedOptions: React.PropTypes.object,
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

  componentWillUpdate: function (nextProps, nextState) {
    if(!_.isEqual(this.props, nextProps)) {
      this.setState({loading: true});
      this.isLoading();
    }
  },

  isLoading: function () {
    var that = this;
    $(this.refs.dressPreview).imagesLoaded({background: true}).always(function (instance) {
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

  imageNotFoundHandle: function (e) {
    var image = e.target;
    image.src = '/assets/wedding-atelier/dresses/not-found.gif';
    return true;
  },

  dressDescription: function(){
    var silhouette = this.props.selectedOptions.silhouette;
    if(silhouette){
      return silhouette.description.split("\\n").map(function(text){return(<p>{text}</p>)})
    }
  },

  renderThumbnails: function (images) {
    var that = this;
    var thumbnails = images.map(function (image, index) {
      var classes = classNames({
        'dress-preview-thumbnails-item': true,
        'selected': index === that.state.selectedImageIndex
      });
      var key = 'dress-preview-thumb' + index;

      return (
        <li key={key} className={classes} onClick={that.thumbnailSelectedHandle.bind(null, index)}>
          <img src={image.thumbnail.white} onError={that.imageNotFoundHandle}/>
        </li>
      );
    });

    return (
      <ul className="dress-preview-thumbnails">
        {thumbnails}
      </ul>
    );
  },

  isCustomDress: function(){
    var options = this.props.selectedOptions,
        lengthName = options.length && options.length.name,
        lengthSet = !(lengthName == undefined) && lengthName!='AK'
    return options.style || options.fit || lengthSet;
  },

  getImage: function(images){
    var image = images[this.state.selectedImageIndex];
    return this.isCustomDress() ? image.normal : image.real.large;
  },

  render: function() {
    var images = new DressImageBuilder(this.props.selectedOptions).dressCombos(),
        silhouette = this.props.selectedOptions.silhouette;
    return (
      <div ref="dressPreview" className="dress-preview">
        <div className="preview">
          <img src={this.getImage(images)}
            style={{visibility: this.state.loading? 'hidden' : 'visible'}}
            onClick={this.zoomClickedHandle}
            onError={this.imageNotFoundHandle}/>
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
                <p className="dress-preview-details-title">{silhouette ? 'The ' + silhouette.name : ''}</p>
                <div className="dress-preview-details-text-long">{this.dressDescription()}</div>
                <p className="dress-preview-details-disclaimer">Please note: These images act as a guide, and there may be slight variations in your final product.</p>
              </div>
            </div>
          </div>
        </div>
        <div
          className="dress-preview-pagination"
          style={{display: this.state.showDetails? 'none':'block'}}>
          {this.renderThumbnails(images)}
        </div>
        <ZoomModal
          images={images}
          selectedImageIndex={this.state.selectedImageIndex}
          visible={this.state.zoom}
          zoomClosedHandle={this.zoomClosedHandle}
          thumbnailSelectedHandle={this.thumbnailSelectedHandle}
          isCustomDress={this.isCustomDress()}
          imageNotFoundHandle={this.imageNotFoundHandle}/>
      </div>
    );
  }
});
