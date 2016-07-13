import React, {PropTypes} from 'react';
import {connect} from 'react-redux';
import Enquire from 'enquire.js';

class PdpGallery extends React.Component {
  constructor() {
    super();

    this.initGallery = this.initGallery.bind(this);
  }

  componentDidMount() {
    this.initGallery();
  }

  componentDidUpdate() {
    this.initGallery();
  }

  initGallery() {
    Enquire.register('screen and (max-width: 992px)', {
      match: () => {
        $('.js-pdp-hero-gallery').slick({
          arrows: false,
          dots: true,
          slidesToShow: 2,
          slidesToScroll: 2,
          responsive: [
            {
              breakpoint: 768,
              settings: {
                slidesToShow: 1,
                slidesToScroll: 1
              }
            }
          ]
        });
      },
      unmatch: () => {
        $('.js-pdp-hero-gallery').slick('unslick');
      }
    });
  }

  render() {
    const images = this.props.product.images.map((image, index) => {
      if(image.table.color_id === this.props.customize.color.id) {
        return (
          <div className="media-wrap" key={index}>
            <img src={image.table.original} alt="Product image" />
          </div>
        );
      }
    });
    return (
      <div className="panel-media">
        <div className="panel-media-inner-wrap js-pdp-hero-gallery">
          {images}
        </div>
      </div>
    );
  }

}

PdpGallery.propTypes = {
  customize: PropTypes.object.isRequired,
  product: PropTypes.object.isRequired
};

function mapStateToProps(state, ownProps) {
  return {
    customize: state.customize,
    product: state.product
  };
}

export default connect(mapStateToProps)(PdpGallery);
