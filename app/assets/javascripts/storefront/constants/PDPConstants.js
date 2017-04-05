import { assign } from 'lodash';

function generateInchesSizing() {
  const sizes = [];
  for (let i = 0; i < 20; i += 1) {
    const id = i;
    const ft = 5 + Math.floor(i / 12);
    const inch = i % 12;
    const totalInches = (ft * 12) + inch;
    sizes.push({ id, ft, inch, totalInches });
  }
  return sizes;
}
const constants = assign({},
  { INCH_SIZES: generateInchesSizing() },
);

export default constants;
