export function convertHeightUnits(heightValue, heightUnit) {
  if (!heightValue || !heightUnit) {
    return null;
  }

  if (heightUnit === 'inch') {
    return `${Math.floor(parseInt(heightValue, 10) / 12)}ft ${parseInt(heightValue, 10) % 12}in`;
  }
  return `${heightValue}cm`;
}

export function displayHeight(heightValue, heightUnit, height) {
  if (heightValue && heightUnit) {
    return convertHeightUnits(heightValue, heightUnit);
  }
  return height;
}
