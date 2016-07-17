import React, {PropTypes} from 'react';
import {connect} from 'react-redux';
import {Scrollspy} from 'react-scrollspy';
import {StickyContainer, Sticky} from 'react-sticky';
import Slick from 'react-slick';

class PdpGallery extends React.Component {
  constructor() {
    super();

    this.state = {
      imageWidth: 0
    };

    this.handleResize = this.handleResize.bind(this);
  }

  componentDidMount() {
    window.addEventListener('resize', this.handleResize);
  }

  componentWillUnmount() {
    window.removeEventListener('resize', this.handleResize);
  }

  handleResize() {
    this.setState({imageWidth: 0});
  }

  render() {
    let foundImage = false;
    let thumbIds = [];

    const SETTINGS = {
      infinite: true,
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
    };

    const STYlE = {
      marginLeft: (this.state.imageWidth / 2) * -1
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
          <div className="media-wrap" key={index}>
            <span id={id} className="scrollspy-trigger"></span>
            <img src={image.url} alt={image.alt} onLoad={this.handleImageLoaded} />
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
