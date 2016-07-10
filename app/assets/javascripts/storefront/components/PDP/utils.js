export const GetDressVariantId = (vars, color, size) => {
  let id;
  vars.map((val) => {
    if(parseInt(val.table.color_id) === parseInt(color)
      && parseInt(val.table.size_id) === parseInt(size)) {
      id = val.table.id;
    }
  });
  return id;
};
