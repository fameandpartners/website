/* eslint-disable*/

console.log('init_shopping_spree file');

window.onload = function () {
  console.log('init_shopping_spree: onload');

  var bodyEl = document.body;

  bodyEl.addEventListener('click', function(e) {
    if (e.target && e.target.matches('.js-shop-with-friends')) {
      e.preventDefault();
      window.startShoppingSpree();
    }
  });
};
