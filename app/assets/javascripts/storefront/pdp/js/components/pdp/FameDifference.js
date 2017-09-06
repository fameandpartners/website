import React, { PureComponent } from 'react';
import aerialImage from '../../../img/test/aerial.png';
import handmadeImage from '../../../img/test/handmade.png';

/* eslint-disable react/prefer-stateless-function */
class FameDifference extends PureComponent {
  render() {
    return (
      <div className="FameDifference typography">
        <h3>The Fame Difference</h3>
        <p className="u-mb-normal">
          Our ethical, made-to-order model means less waste
          since we don&apos;t carry and store excess stock
        </p>
        <div className="grid-center">
          <div className="col-12">
            <img className="u-width--full" src={aerialImage} alt="Sewing and designing" />
          </div>
          <div className="FameDifference__artisan-quality col-4_sm-12_md-5 grid-middle">
            <div className="FameDifference__artisan col h5">
              Artisan quality, our clothing is handmade by artisan seamstresses
              using time-honored techniques.
            </div>
            <p>
              Our ethical made-to-order model made-to-order means less waste,
              since we don&apos;t carry and store.
            </p>
          </div>
          <div className="FameDifference__hand col-8_sm-12_md-7">
            <img className="u-width--full" src={handmadeImage} alt="Hand designing" />
          </div>
        </div>
      </div>
    );
  }
}

export default FameDifference;
