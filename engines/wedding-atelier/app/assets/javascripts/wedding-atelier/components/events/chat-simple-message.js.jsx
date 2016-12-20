var ChatSimpleMessage = React.createClass({

  formatDate: function(time) {

    var leadZero = function(val) {
      return ('0' + val).slice(-2);
    }

    if (!time) return;

    var t = new Date(time);
    var formatted = '';

    day = t.getDate();
    month = leadZero(t.getMonth() + 1);
    time = t.getHours() + ':' + leadZero(t.getMinutes()) + 'hrs';

    if (day === (new Date).getDate()) {
      formatted += 'today, ' + time
    } else {
      formatted += day + '/' + month + ', ' + time
    }

    return formatted;
  },

  render: function() {
    if (this.props.message.time) {
      var formattedDate = this.formatDate(this.props.message.time);
    } else {
      formattedDate = '......'
    }

    return(
        <div className="msg-simple">
          <div className="msg-data">
            <div className="profile">
              <img className="photo" src={this.props.message.profilePhoto} />
              <span className="name">{this.props.message.author}</span>
              <span className="created pull-right">{formattedDate}</span>
            </div>
          </div>
          <div className="msg-text">
            {this.props.message.content}
          </div>
        </div>
    )
  }
});
