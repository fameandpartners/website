import React, {PropTypes} from 'react';
import {connect} from 'react-redux';
import {Scrollspy} from 'react-scrollspy';
import Slick from 'react-slick';

class PdpGallery extends React.Component {
  constructor() {
    super();

    this.handleLoad = this.handleLoad.bind(this);
    this.handleResize = this.handleResize.bind(this);
    this.calculateOffset = this.calculateOffset.bind(this);
  }

  componentDidMount() {
    window.addEventListener('resize', this.handleResize);
    this.handleResize();
  }

  componentWillUnmount() {
    window.removeEventListener('resize', this.handleResize);
  }

  handleLoad(image) {
    image.target.style.marginLeft = this.calculateOffset(image.target) + 'px';
    image.target.parentNode.className += ' is-loaded';
    $(image.target.parentNode).zoom({
      url: image.target.getAttribute('src'),
      touch: true,
      on: 'grab',
      duration: 50,
      magnify: 1.3,
      onZoomIn: function() {
        this.parentNode.classList.add('zoomed-in');
      },
      onZoomOut: function() {
        this.parentNode.classList.remove('zoomed-in');
      }
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

    if (image.clientWidth > image.parentNode.clientWidth && window.outerWidth >= 992) {
      let offset = ((image.clientWidth / 2) - (image.parentNode.clientWidth / 2)) * -1;

      // If image is old (e.g. Skirts), move images only 30% to the left
      if(image.naturalWidth > 1700) { offset = offset * MOVE_LEFT_PERCENT; }

      return offset;
    }
  }

  render() {
    let filteredImages = [];
    let thumbIds = [];

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

    // Step 1 - match color and customization
    filteredImages = this.props.images.filter((image) => {
      return image.color_id === this.props.customize.color.id
        && image.customization_id === this.props.customize.customization.id;
    });

    // Step 2 - if step 1 failed try to match just color
    if(filteredImages.length === 0) {
      filteredImages = this.props.images.filter((image) => {
        return image.color_id === this.props.customize.color.id;
      });
    }

    // Step 3 - if step 2 failed try to match default color with customization
    if(filteredImages.length === 0) {
      filteredImages = this.props.images.filter((image) => {
        return image.color_id === this.props.product.featured_image.table.color_id
          && image.customization_id === this.props.customize.customization.id;
      });
    }

    // Step 4 - if step 3 failed try to match just the default color
    if(filteredImages.length === 0) {
      filteredImages = this.props.images.filter((image) => {
        return image.color_id === this.props.product.featured_image.table.color_id
          && image.customization_id === undefined;
      });
    }

    let images = filteredImages.map((image, index) => {
      if(image) {
        let id = "gallery-image-" + index;
        thumbIds.push(id);
        return (
          <div className="media-wrap-outer" key={index}>
            <div className="media-wrap">
              <span id={id} className="scrollspy-trigger"></span>
              <img src={image.url} alt={image.alt}
                className="js-gallery-image" onLoad={this.handleLoad} />
              <span className="loader"></span>
              <span className="btn-close expande lg">
                <span className="hide-visually">tap to zoom</span>
              </span>
              <span className="btn-zoom">tap to zoom</span>
            </div>
          </div>
        );
      }
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
