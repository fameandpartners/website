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
