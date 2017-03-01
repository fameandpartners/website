function WeddingAtelierHelper(){}

WeddingAtelierHelper.chatTimestamp = function(time){
    if (!time) {
      return '';
    }
    return moment(new Date(time)).calendar(null, {
      sameDay: '[Today], hh:mmA',
      lastDay: '[Yesterday], hh:mmA',
      lastWeek: 'MM/DD/YYYY, hh:mmA',
      sameElse: 'MM/DD/YYYY, hh:mmA'
    });
};

WeddingAtelierHelper.notify = function(errors){
  var component = React.createElement(Notification, { errors: errors });
  ReactDOM.render(component, document.getElementById('notification'));
};
