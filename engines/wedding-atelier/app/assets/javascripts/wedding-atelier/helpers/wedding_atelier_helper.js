function WeddingAtelierHelper(){}

WeddingAtelierHelper.chatTimestamp = function(time){
    if (!time) {
      return '';
    }
    return moment(new Date(time)).calendar(null, {
      sameDay: '[Today], hh:mm:a',
      lastDay: '[Yesterday], hh:mm:a',
      sameElse: 'MM/DD/YYYY, hh:mm:a'
    });
};
