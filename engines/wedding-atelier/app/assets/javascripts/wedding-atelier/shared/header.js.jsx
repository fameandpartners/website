(function() {
  $(document).ready(function () {
    $('.commands-help').on('click', function (e) {
      ReactDOM.render(<Help />, document.getElementById('notification'));
    });
  });
}());
