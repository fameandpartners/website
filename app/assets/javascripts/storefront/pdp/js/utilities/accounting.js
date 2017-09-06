import accounting from 'accounting';

function formatCents(centsTotal, precision = 2, curr = '$') {
  return accounting.formatMoney((centsTotal / 100), curr, precision);
}

export default { formatCents };
