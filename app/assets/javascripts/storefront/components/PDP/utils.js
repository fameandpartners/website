// this is just reset, proper styling will be applied through SASS
export const MODAL_STYLE = {
  overlay: {
    backgroundColor: null
  },
  content: {
    position: null,
    top: null,
    left: null,
    right: null,
    bottom: null,
    border: null,
    background: null,
    overflow: null,
    WebkitOverflowScrolling: null,
    borderRadius: null,
    padding: null
  }
};

// This will attempt to find a variant ID
// It will succeed only for the default colors
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

// Update URL on dress color change
export const UpdateUrl = (colorId, paths) => {
  let url;

  if(paths) {
    if(paths[colorId]) {
      url = paths[colorId];
    } else {
      url = paths.default;
    }
  }

  window.history.replaceState({path: url}, '', url);
};
