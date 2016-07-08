export const GetDressVariantId = (vars, color, size) => {
  let id;
  vars.map(val => {
    if(parseInt(val.color_id) === parseInt(color)
      && parseInt(val.size_id) === parseInt(size)) {
      id = val.id;
    }
  });
  return id;
};
