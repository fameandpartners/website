import React, {PropTypes} from 'react';

class ImageMagnifier extends React.Component {
  constructor() {
    super();

    this.state = {
      imageWidth: 0,
      heightWidth: 0
    };

    this.handleLoad = this.handleLoad.bind(this);
  }

  handleLoad(image) {
    console.log(image.target.width);
    this.setState = {
      imageWidth: image.target.width,
      heightWidth: image.target.height
    };
  }

  render() {
    return (
      <div style={{
        position: "absolute",
        top: 0,
        left: 0,
        right: 0,
        bottom: 0
      }}>
        <img src={this.props.src} alt={this.props.alt} onLoad={this.handleLoad} />
        <div style={{
          position: "absolute",
          width: this.state.imageWidth,
          height: this.state.imageHeight,
          backgroundImage: `url(${this.props.src})`,
          backgroundRepeat: 'no-repeat'
        }}></div>
      </div>
    );
  }

}

ImageMagnifier.propTypes = {
  src: PropTypes.string,
  alt: PropTypes.string
};

export default ImageMagnifier;
