import React, {PropTypes} from 'react';
import {connect} from 'react-redux';
import Enquire from 'enquire.js';
import {Scrollspy} from 'react-scrollspy';
import {StickyContainer, Sticky} from 'react-sticky';

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
          infinite: false,
          arrows: false,
          dots: true,
          customPaging: function() {
            return '<a href="javascript:;"></a>';
          },
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
    let foundImage = false;
    let thumbIds = [];

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
    const IMAGES = this.props.images.map((image, index) => {
      if(image.color_id === COLOR_ID) {
        let id = "gallery-image-" + index;
        thumbIds.push(id);
        return (
          <div className="media-wrap" key={index}>
            <span id={id} className="scrollspy-trigger"></span>
            <img src={image.url} alt={image.alt} />
          </div>
        );
      }
    });

    return (
      <div className="panel-media">
        <StickyContainer className="panel-media-inner-wrap js-pdp-hero-gallery">
          {IMAGES}
          <Sticky topOffset={80} className="scrollspy-thumbs">
            <Scrollspy items={thumbIds}
              currentClassName="is-selected">
              {thumbIds.map((id, index) => {
                let selector = "#" + id;
                return (
                  <li key={index}>
                    <a href={selector}></a>
                  </li>
                );
              })}
            </Scrollspy>
          </Sticky>
        </StickyContainer>
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
