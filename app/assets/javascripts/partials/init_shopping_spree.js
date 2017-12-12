/* eslint-disable*/

window.onload = function () {
  var bodyEl = document.body;

  bodyEl.addEventListener('click', function(e) {
    if (e.target && e.target.matches('.js-shop-with-friends')) {
      e.preventDefault();
      window.startShoppingSpree();
    }
  });
};
