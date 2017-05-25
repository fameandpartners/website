import React, {PropTypes} from 'react';
import {connect} from 'react-redux';
import {Scrollspy} from 'react-scrollspy';
import Slick from 'react-slick';
import { trackEvent } from '../../libs/gaTracking'
import { selectPhotoEvent } from '../../libs/gaEventObjects'

class PdpGallery extends React.Component {
  constructor() {
    super();

    this.handleLoad = this.handleLoad.bind(this);
    this.handleResize = this.handleResize.bind(this);
    this.calculateOffset = this.calculateOffset.bind(this);
    this.state = { loaded: {}, margin: {}, zoom: {} }
  }

  componentDidMount() {
    window.addEventListener('resize', this.handleResize);
    this.handleResize();
  }
  componentWillUnmount() {
    window.removeEventListener('resize', this.handleResize);
  }

  zoomImage(stateId, shouldZoom) {
    let zoomObj = this.state.zoom;
    zoomObj[stateId] = shouldZoom;
    this.setState({ zoom: zoomObj });
  }
 
  handleLoad(event) {
    let loadedObj = this.state.loaded;
    let marginObj = this.state.margin;

    let imageId = event.target.id

    loadedObj[imageId] = true;
    marginObj[imageId] = this.calculateOffset(event.target);

    this.setState({ loaded: loadedObj, margin: marginObj });

    $(event.target.parentNode).zoom({
      url: event.target.getAttribute('src'),
      touch: true,
      on: 'grab',
      duration: 50,
      magnify: 1.3,
      onZoomIn: this.zoomImage.bind(this, imageId, true),
      onZoomOut: this.zoomImage.bind(this, imageId, false)
    });
  }

  handleResize() {
    const IMAGES = document.getElementsByClassName('js-gallery-image');
    [...IMAGES].map((image) => {
      image.style.marginLeft = this.calculateOffset(image) + 'px';
    });
  }

  calculateOffset(image) {
    // calculate image offset
    const MOVE_LEFT_PERCENT = 0.3;
    let desktopMinWidth = 992;
    let oldImageWidth = 1700;

    if (image.clientWidth > image.parentNode.clientWidth && window.outerWidth >= desktopMinWidth) {
      let offset = ((image.clientWidth / 2) - (image.parentNode.clientWidth / 2)) * -1;

      // If image is old (e.g. Skirts), move images only 30% to the left
      if(image.naturalWidth > oldImageWidth) { 
        offset = offset * MOVE_LEFT_PERCENT; 
      }

      return offset;
    }
  }
  render() {
    let galleryImages = [];
    let thumbIds = [];
    let defaultColors = this.props.product.available_options.table.colors.table.default;
    let defaultColorIds = defaultColors.map(color => color.option_value.id);

    let [ render3dImages, photos ] = this.props.images.reduce((acc, image) => {
      if (image.customization_id !== undefined) {
        acc[0].push(image);
      } else {
        acc[1].push(image);
      }

      return acc;
    }, [[], []]);

    if (
      defaultColorIds.includes(this.props.customize.color.id) 
        && !$.isNumeric(this.props.customize.customization.id)
        || !render3dImages.length
    ) {
      galleryImages = photos.filter((image) => {
        return image.color_id === this.props.customize.color.id;
      });

    } else {
      galleryImages = render3dImages.filter((image) => {
        return image.color_id === this.props.customize.color.id
          && image.customization_id === (this.props.customize.customization.id || 0);
      });
    }

    // TODO: Alexey Bobyrev 08/11/16
    // Rewrite filtering logic to avoid empty gallery!

    // NOTE: Alexey Bobyrev 08/11/16
    // Fallback to non-render3d product w/o images for custom colors
    if (!galleryImages.length) {
      galleryImages = photos.filter(image => {
        return this.props.product.default_image.table.color_id === image.color_id
      });
    } 

    // NOTE: Alexey Bobyrev 08/11/16
    // If there is no images to default product color then we apply all available photo images
    if (!galleryImages.length) {
      galleryImages = photos;
    }

    const SETTINGS = {
      infinite: true,
      arrows: false,
      dots: true,
      swipe: false,
      responsive: [
        {
          breakpoint: 992,
          settings: {
            slidesToShow: 1,
            slidesToScroll: 1
          }
        },
        {
          breakpoint: 9999,
          settings: 'unslick'
        }
      ]
    };


    let images = galleryImages.map((image, index) => {
      let id = `gallery-image-${index}`;
      let stateId = `image-${image.id}`;
      let loadedClass = this.state.loaded[stateId] ? 'is-loaded' : '';
      let zoomClass = this.state.zoom[stateId] ? 'zoom-in' : '';
      let style = { marginLeft: `${this.state.margin[stateId]}px` };

      thumbIds.push(id);

      return (
        <div className="media-wrap-outer" key={index} onClick={() => this.trackEvent(selectPhotoEvent, true, index)}>
          <div className={`media-wrap ${loadedClass} ${zoomClass}`}>
            <span id={id} className="scrollspy-trigger"></span>
            <img src={image.url} alt={image.alt} id={stateId}
              style={style}
              className="js-gallery-image" onLoad={this.handleLoad} />
            <span className="loader"></span>
            <span className="btn-close expande lg">
              <span className="hide-visually">tap to zoom</span>
            </span>
            <span className="btn-zoom">tap to zoom</span>
          </div>
        </div>
      );
    });

    images = images.filter((n) => {
      return n !== undefined;
    });

    return (
      <div className="panel-media-inner-wrap">
        <Slick {...SETTINGS}>
          {images.map((item, index) => (<div key={index}>{item}</div>))}
        </Slick>
        <div className="scrollspy-thumbs">
          {thumbIds.map((id, index) => {
            let selector = "#" + id;
            return (
              <li key={index}>
                <a href={selector}></a>
              </li>
            );
          })}
        </div>
      </div>
    );
  }

}

PdpGallery.propTypes = {
  customize: PropTypes.object.isRequired,
  product: PropTypes.object.isRequired,
  images: PropTypes.array.isRequired
};

function mapStateToProps(state, ownProps) {
  return {
    customize: state.customize,
    product: state.product,
    images: state.images
  };
}

export default connect(mapStateToProps)(PdpGallery);
