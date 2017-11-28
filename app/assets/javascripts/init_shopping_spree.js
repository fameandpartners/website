/* eslint-disable*/

window.onload = function () {
  var headerArr = document.getElementsByClassName('Header');

  for (var i = 0; i < headerArr.length; i++) {
    headerArr[i].addEventListener('click', function(e) {
      if (e.target && e.target.matches('.js-shop-with-friends')) {
        e.preventDefault();
        window.startShoppingSpree();
      }
    })
  }
};
