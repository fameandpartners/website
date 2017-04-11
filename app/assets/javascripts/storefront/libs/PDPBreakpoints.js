export default {
  debounce: 500,
  onResize(win) {
    const { innerWidth: winWidth } = win;
    let breakpoint = 'mobile';
    if (win.innerWidth >= 991) {
      breakpoint = 'desktop';
    }
    return { breakpoint, winWidth };
  },
};
