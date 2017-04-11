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
    INCH_SIZES: generateInchesSizing(),
    MIN_CM: 147,
    MAX_CM: 193,
    DRAWERS: {
      SIZE_PROFILE: 'SIZE_PROFILE',
    },
    UNITS: {
      INCH: 'inch',
      CM: 'cm',
    },
  },
);

export default constants;
