/**
 * IMMUTABLE Removes option in array if present, adds to end if not
 * @param  {Array} selectedOptions
 * @param  {String} val
 * @return {Array} new array of values
 */
export function addOrRemoveFrom(selectedOptions, changeOption) {
  let newSelections = [];
  const selectedOptionIndex = selectedOptions.indexOf(changeOption);
  if (selectedOptionIndex > -1) {
    newSelections = [
      ...selectedOptions.slice(0, selectedOptionIndex),
      ...selectedOptions.slice(selectedOptionIndex + 1),
    ];
  } else {
    newSelections = selectedOptions.concat(changeOption);
  }
  return newSelections;
}

export default {
  addOrRemoveFrom,
};
