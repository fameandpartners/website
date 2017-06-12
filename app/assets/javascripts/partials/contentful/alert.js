
console.log('partials/contentful/alert.js');

if (!window.helpers) { window.helpers = {}; }

window.helpers.showAlert = function(opts) {
  let icon, title;
  let type = opts.type || 'warning';
  if (type === 'success') {
    title = opts.title || "awesome babe";
    icon = 'fa-heart-o';
  } else {
    title = opts.title || "sorry";
    icon = 'fa-frown-o';
  }

  let message = `<h3>${title}</h3><p><span class=\"fa fa-icon ${icon}\"></span> ${opts.message}</p>`;

  vex.dialog.buttons.YES.text = 'X';
  vex.dialog.alert({
    message,
    className: `vex vex-theme-bottom-right-corner alert alert-${type} ${opts.className || ''}`,
    afterOpen() {
      return $('.vex-dialog-buttons button').addClass('btn btn-black');
    }
  }); // HACKETRY

  return setTimeout(vex.close, opts.timeout || 5555);
};
