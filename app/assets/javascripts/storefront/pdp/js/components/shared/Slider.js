import React, { Component } from 'react';
import PropTypes from 'prop-types';
import autoBind from 'react-autobind';
import '../../../css/components/Slider.scss';

import { lory } from '../../libs/lory';

let loryInstance = null;
class Slider extends Component {
  constructor(props) {
    super(props);
    autoBind(this);
  }

  componentDidMount() {
    loryInstance = lory(this.slider, {
      infinite: 1,
      classNameFrame: 'Slider__frame',
      classNameSlideContainer: 'Slider__slides',
    });
  }

  componentDidUpdate(lastProps) {
    if ((lastProps.winWidth !== this.props.winWidth)
  || (lastProps.winHeight !== this.props.winHeight)) {
      loryInstance.reset();
    }
  }

  render() {
    const { children, sliderHeight } = this.props;

    return (
      <div
        ref={c => this.slider = c}
        className="Slider u-height--full"
        style={{ height: sliderHeight }}
      >
        <div className="Slider__view u-height--full">
          <div className="Slider__frame u-height--full">
            <ul className="Slider__slides u-height--full">
              { children }
            </ul>
          </div>
        </div>
      </div>
    );
  }
}

Slider.propTypes = {
  children: PropTypes.oneOfType([
    PropTypes.array,
    PropTypes.node,
  ]).isRequired,
  sliderHeight: PropTypes.string.isRequired,
  winHeight: PropTypes.number,
  winWidth: PropTypes.number,
};

Slider.defaultProps = {
  winHeight: null,
  winWidth: null,
};

export default Slider;
