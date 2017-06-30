var EventFields = React.createClass({
  nextStep: function(e) {
    e.preventDefault();

    var data = {
      events_attributes: {
        '0': {
          event_type: 'wedding',
          name: this.refs.event_name.value,
          date: this.refs.event_date.value,
          number_of_assistants: this.refs.event_number_of_assistants.value
        }
      },
      event_role: this.refs.user_role.value
    }

    this.props.saveValues(data)
    this.props.nextStep()
  },

  componentDidMount: function() {

    $(this.refs.event_number_of_assistants).incrementButton();

    $(this.refs.event_date)
    .datepicker({
      format: "mm/dd/yyyy",
      autoclose: true,
      showOnFocus: true,
      startDate: moment().format('M/D/YYYY')
    });
  },

  render: function() {
    return (
      <div className="registrations__details-form signup left-side-centered-container">
        <h1 className="text-center">Tell us about the event.</h1>
        <div className="form">
          <div className="form-group">
            <label>What should we call your wedding?</label>
            <input className="form-control" ref="event_name" />
          </div>

          <div className="form-group">
            <label>What's your Role?</label>

            <select className="form-control" id="wedding_role" ref="user_role">
              <option value="">Select one</option>
              <option value="bride">Bride</option>
              <option value="bridesmaid">Bridesmaid</option>
              <option value="maid of honor">Maid of Honor</option>
              <option value="mother of bride">Mother of Bride</option>
            </select>
          </div>

          <div className="form-group">
            <label>Whens the Wedding?</label>
            <div className="input-group date date-picker">
              <input className="form-control wedding-date" data-outside-error="true" ref="event_date" onkeydown="return false" placeholder="mm/dd/yyyy" />
              <span className="input-group-addon">
                <i className="calendar-icon"></i>
              </span>
            </div>
          </div>

          <div className="form-group">
            <label>How Many Bridesmaids?</label>
            <div className="number-field">
              <input className="form-control number-field" min="0" ref="event_number_of_assistants" type="number" />
            </div>
          </div>

        </div>
        <input className="btn btn-black full-width" defaultValue="next" onClick={this.nextStep} type="button" />
      </div>
    );
  }
});

