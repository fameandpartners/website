function WeddingAtelierHelper(){}

WeddingAtelierHelper.chatTimestamp = function(time){
    if (!time) {
      return '';
    }
    return moment(new Date(time)).calendar(null, {
      sameDay: '[Today], hh:mmA',
      lastDay: '[Yesterday], hh:mmA',
      sameElse: 'MM/DD/YYYY, hh:mmA'
    });
};
