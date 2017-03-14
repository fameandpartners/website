var EventDetails = React.createClass({

  propTypes: {
    current_user: React.PropTypes.object,
    event: React.PropTypes.shape({
      date: React.PropTypes.string,
      hasError: React.PropTypes.object,
      name: React.PropTypes.string,
      number_of_assistants: React.PropTypes.number,
      role: React.PropTypes.string
    }),
    eventDetailsUpdated: React.PropTypes.func,
    eventDetailsUpdateFailed: React.PropTypes.func,
    eventDetailsUpdatePath: React.PropTypes.string,
    hasError: React.PropTypes.object,
    roles_path: React.PropTypes.string
  },

  getInitialState: function() {
    return {
      event: {}
    };
  },

  componentDidMount: function() {
    $(this.refs.numberfield).incrementButton({
      onChange: this._onChangeInput
    });

    $(this.refs.datepicker)
    .datepicker({
      format: "mm/dd/yyyy",
      autoclose: true,
      showOnFocus: true,
      startDate: moment().format('M/D/YYYY')
    }).on('show', function(e){
      $(this).addClass('active');
    }).on('hide', function(e){
      $(this).removeClass('active');
    }).on('changeDate', function(e){
      var date = $(e.target).find('input').val();
      var _newState = $.extend({}, this.state);
      _newState.event.date = date;
      this.setState(_newState);
    }.bind(this));
  },

  componentWillReceiveProps: function (nextProps) {
    if(Object.keys(this.state.event).length === 0) {
      this.setState({event: $.extend({}, nextProps.event)});
    }
  },

  getEventDetailsUpdatePromise: function(e) {
    var event = $.extend({}, this.state.event);
    if(event.number_of_assistants == ''){ event.number_of_assistants = 0; }
    return $.ajax({
      data: { event: event },
      dataType: 'json',
      type: 'PUT',
      url: this.props.eventDetailsUpdatePath
    });
  },

  _onChangeInput: function(e) {
    var _newState = $.extend({}, this.state);
    _newState.event[e.target.name] = e.target.value;
    this.setState(_newState);
  },

  render: function() {
    return (
        <form className="center-block registrations__details-form">
          <div className={this.props.hasError && this.props.hasError.name ? 'form-group has-error' : 'form-group'}>
            <label htmlFor="input_wedding_board_name">
              What should we call your wedding board?
            </label>
            <input id="input_wedding_board_name"
                   className="form-control"
                   placeholder=""
                   type="text"
                   name="name"
                   value={this.state.event.name}
                   onChange={this._onChangeInput} />
          </div>
          <div className="form-group">
            <label htmlFor="input_event_role">
              What is your role in the wedding?
            </label>

            <Roles id="input_event_role"
                ref="role"
                onChange={this._onChangeInput}
                current_user={this.props.current_user}
                roles_path={this.props.roles_path} />
          </div>
          <div className="form-group">
            <label htmlFor="input_number_of_assistants">
              How many bridesmaids will be in the wedding?
            </label>
            <input type="number"
                   className="form-control number-field js-number-field"
                   min="0"
                   max="100"
                   id="input_number_of_assistants"
                   name="number_of_assistants"
                   ref="numberfield"
                   value={this.state.event.number_of_assistants}
                   onChange={this._onChangeInput} />
          </div>
          <div className="form-group">
            <label htmlFor="input_date">What is the date of the wedding?</label>
            <div className="input-group date date-picker" ref="datepicker">
              <input
                  type="text"
                  className="form-control wedding-date"
                  placeholder="mm/dd/yyyy"
                  name="date"
                  id="input_date"
                  readOnly="readonly"
                  value={this.state.event.date}
                  onChange={this._onChangeInput}/>
              <span className="input-group-addon">
                <i className="calendar-icon"></i>
              </span>
            </div>
          </div>
          <div className="form-group text-center">
            <FeedbackButton
              className="center-block"
              failureHandler={this.props.eventDetailsUpdateFailed}
              label={'Save'}
              labelCompleted={'Saved'}
              promise={this.getEventDetailsUpdatePromise}
              successHandler={this.props.eventDetailsUpdated} />
          </div>
        </form>
    );
  }
});
