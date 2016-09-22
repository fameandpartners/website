import React, {PropTypes} from 'react';
import {connect} from 'react-redux';
import {Scrollspy} from 'react-scrollspy';
import Slick from 'react-slick';

class PdpGallery extends React.Component {
  constructor() {
    super();

    this.state = {
      slickEnabled: false
    };

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
      url: $(image.target).attr('src'),
      touch: true,
      on: 'click',
      duration: 50,
      magnify: 1.3,
      onZoomIn: function() {
        $(this).parent().addClass('zoomed-in');
      },
      onZoomOut: function() {
        $(this).parent().removeClass('zoomed-in');
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
      if(image.naturalWidth > 1600) { offset = offset * MOVE_LEFT_PERCENT; }

      return offset;
    }
  }

  render() {
    let foundImage = false;
    let thumbIds = [];

    const SLICK_ENABLED = this.state.slickEnabled;

    const SETTINGS = {
      infinite: true,
      arrows: false,
      dots: true,
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
      ],
      beforeChange: function(e) {
        console.log(e);
        if(!SLICK_ENABLED){
          e.preventDefault();
        }
      }
    };

    // check if selected color ID matches any available images
    this.props.images.map((image, index) => {
      if(image.color_id === this.props.customize.color.id) {
        foundImage = true;
      }
    });

    // if no match found, use default dress color
    const COLOR_ID = foundImage
      ? this.props.customize.color.id
      : this.props.product.color_id;

    // match color id with images
    let images = this.props.images.map((image, index) => {
      if(image.color_id === COLOR_ID) {
        let id = "gallery-image-" + index;
        thumbIds.push(id);
        return (
          <div className="media-wrap-outer" key={index}>
            <div className="media-wrap">
              <span id={id} className="scrollspy-trigger"></span>
              <img src={image.url} alt={image.alt}
                className="js-gallery-image" onLoad={this.handleLoad} />
              <span className="loader"></span>
              <span className="btn-close expande lg"></span>
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
