var EventDetails = React.createClass({

  propTypes: {
    roles_path: React.PropTypes.string,
    eventDetailsUpdatePath: React.PropTypes.string,
    eventDetailsUpdated: React.PropTypes.func,
    eventDetailsUpdateFailed: React.PropTypes.func,
    current_user: React.PropTypes.object,
    event: React.PropTypes.shape({
      name: React.PropTypes.string,
      number_of_assistants: React.PropTypes.number,
      date: React.PropTypes.string,
      role: React.PropTypes.string,
      hasError: React.PropTypes.object
    }),
  },

  getInitialState: function() {
    return {
      event: this.props.event
    }
  },

  componentDidMount: function() {
    $(this.refs.numberfield).incrementButton({
      onChange: this._onChangeInput
    });

    $(this.refs.datepicker)
    .datepicker({
      format: "mm/dd/yyyy",
      autoclose: true,
      showOnFocus: true
    }).on('show', function(e){
      $(this).addClass('active');
    }).on('hide', function(e){
      $(this).removeClass('active');
    }).on('changeDate', function(e){
      var date = $(e.target).find('input').val();
      var _event = this.props.event;
      _event.date = date;
      this.setState({event: _event})
    }.bind(this))
  },

  buildAjax: function(e) {
    return $.ajax({
      data: {event: this.state.event},
      dataType: 'json',
      type: 'PUT',
      url: this.props.eventDetailsUpdatePath
    });
  },

  _onChangeInput: function(e) {
    this.props.event[e.target.name] = e.target.value;
    this.setState({event: this.props.event});
  },

  render: function() {
    return(
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
                   value={this.props.event.name}
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
                   id="input_number_of_assistants"
                   name="number_of_assistants"
                   ref="numberfield"
                   value={this.props.event.number_of_assistants}
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
                  value={this.props.event.date}
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
              promise={this.buildAjax()}
              successHandler={this.props.eventDetailsUpdated}></FeedbackButton>
          </div>
        </form>
    );
  }
});
