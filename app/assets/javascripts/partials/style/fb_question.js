window.style.init_fb_question = function(quiz) {
  try {
    FB.getLoginStatus(function(response) {
      if (response.status === 'connected') {
        FB.api('/me/taggable_friends', 'get', { limit: 30 }, function(response){
          _.each(response.data, function(item, index){
            $block = $('.img-' + (index + 1), $('.invite-friends'));
            $block.css('background-image', 'url(' + item.picture.data.url + ')');
            $block.fadeIn('slow');
           });
         });
      }
    });
    $('a.choose-friends-link').click(function(event){
      event.preventDefault();
      window.track.event('Style Quiz', 'Share', '');
      FB.getLoginStatus(function(response) {
        if (response.status === 'connected') {
          FB.ui(
            {
              method: 'send',
              display: 'iframe',
              link: 'http://www.fameandpartners.com/?utm_campaign=stylequiz&utm_source=fame&utm_medium=www'
            },
            quiz.goToNextStep
          );
        } else {
          FB.ui({
            method: 'send',
            display: 'popup',
            link: 'http://www.fameandpartners.com/?utm_campaign=stylequiz&utm_source=fame&utm_medium=www'
          }
          );
        }
      });
    });
  } catch (exception) {
    console.log(exception)
  }
};
