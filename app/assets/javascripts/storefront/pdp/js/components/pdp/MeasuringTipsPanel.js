import React, { PureComponent } from 'react';

import measuringImage from '../../../img/test/measuring.jpg';

// CSS
import '../../../css/components/MeasuringTipsPanel.scss';

/* eslint-disable react/prefer-stateless-function */
class MeasuringTipsPanel extends PureComponent {
  render() {
    return (
      <div className="MeasuringTipsPanel typography grid-noGutter">
        <div className="MeasuringTipsPanel__fame-tips-wrapper grid-noGutter">
          <div className="col-6_sm-12 u-text-align--center">
            <div className="MeasuringTipsPanel__tip">
              <p>
                FYI - Your results will be the most accurate if
                someone else helps you measure!
              </p>
            </div>
          </div>
          <div className="col-6_sm-12">
            <div className="MeasuringTipsPanel__tip">
              <div className="h6">Fame Tips</div>
              <p>
                Measure yourself in your underwear and, if possible,
                the bra you’d like to wear with the dress. Stand tall
                with your feet together.
              </p>
            </div>
          </div>
        </div>
        <div className="col-6_sm-12">
          <img className="u-width--full" src={measuringImage} alt="Measuring info" />
        </div>
        <div className="col-6_sm-12">
          <ul className="MeasuringTipsPanel__tip">
            <li>
              <div className="h6">Bust</div>
              <p>
                Measure around the fullest part of your chest, keeping
                the tape level to the floor.
              </p>
            </li>
            <li>
              <div className="h6">Underbust</div>
              <p>
                Measure directly under your bust (around your rib cage,
                where your bra band sits), keeping the tape level to the floor.
              </p>
            </li>
            <li>
              <div className="h6">Waist</div>
              <p>
                Measure around your natural waistline (the smallest part
                of your waist).
              </p>
            </li>
            <li>
              <div className="h6">Hips</div>
              <p>
                Measure around the fullest part of your hips. Slim-hipped
                ladies can take this measurement from 20cm/8in below the waistline.
              </p>
            </li>
          </ul>
        </div>
      </div>
    );
  }

}

export default MeasuringTipsPanel;
