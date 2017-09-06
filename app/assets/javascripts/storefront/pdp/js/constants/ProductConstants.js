import { assign } from 'lodash';

function generateInchesSizing() {
  const sizes = [];
  const OFFSET = 10;
  for (let i = OFFSET; i < 29; i += 1) {
    const id = i;
    const ft = 4 + Math.floor(i / 12);
    const inch = i % 12;
    const totalInches = (ft * 12) + inch;
    sizes.push({
      id: id - OFFSET,
      ft,
      inch,
      totalInches,
    });
  }
  return sizes;
}
const constants = assign({},
  {
    AU_SIZES: [4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26],
    US_SIZES: [0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22],
    INCH_SIZES: generateInchesSizing(),
    MIN_CM: 147,
    MAX_CM: 193,
    DRAWERS: {
      SIZE_PROFILE: 'SIZE_PROFILE',
      CAD_CUSTOMIZE: 'CAD_CUSTOMIZE',
    },
    CM_TO_INCHES: 2.54,
    UNITS: {
      INCH: 'inch',
      CM: 'cm',
    },
  },
);

export default constants;
