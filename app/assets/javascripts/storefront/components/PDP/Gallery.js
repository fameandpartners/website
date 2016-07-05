import React from 'react';
import Enquire from 'enquire.js';

class PdpGallery extends React.Component {
  constructor() {
    super();
  }

  componentDidMount() {
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
    return (
      <div className="panel-media">
        <div className="panel-media-inner-wrap js-pdp-hero-gallery">
          <div className="media-wrap">
            <img src="/assets/_temp/product-1.jpg" />
          </div>
          <div className="media-wrap">
            <img src="/assets/_temp/product-2.jpg" />
          </div>
          <div className="media-wrap">
            <img src="/assets/_temp/product-3.jpg" />
          </div>
          <div className="media-wrap">
            <img src="/assets/_temp/product-4.jpg" />
          </div>
          <div className="media-wrap">
            <img src="/assets/_temp/product-5.jpg" />
          </div>
        </div>
      </div>
    );
  }

}

export default PdpGallery;
