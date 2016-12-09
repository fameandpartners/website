var EventDetails = React.createClass({
  getInitialState: function() {
    return { event: []}
  },

  componentDidMount: function() {
    this.setState({event: this.props.event});

    $(this.refs.numberfield).incrementButton();

    $(this.refs.select2).select2({
      minimumResultsForSearch: Infinity
    });

    var _date = this.props.event.date.split('-');
    var _initial_date = _date[1] + '-' + _date[2] + '-' + _date[0];

    $(this.refs.datepicker)
    .datepicker({
      format: "dd/mm/yyyy",
      todayBtn: "linked",
      autoclose: true,
      showOnFocus: true
    }).on('show', function(e){
      $(this).addClass('active');
    }).on('hide', function(e){
      $(this).removeClass('active');
    }).on('changeDate', function(e){
      var date = $(e.target).val();
      var _event = this.state.event;
      _event.date = date;
      this.setState({event: _event})
    }.bind(this))
    .datepicker('update', new Date(_initial_date));

  },

  handleUpdate: function(e) {
    $.ajax({
      url: this.props.update_path,
      type: 'PUT',
      dataType: 'json',
      data: {event: this.state.event},
      success: function(collection) {
        this.setState({event: collection.event});
        $('.has-error').removeClass('has-error');
      }.bind(this),
      error: function(data) {
        parsed = JSON.parse(data.responseText)
        for(var key in parsed.errors) {
          $('input[name="' + key +'"').parent().addClass('has-error')
        };
      }
    });
    e.preventDefault();
  },

  _onChangeInput: function(e) {
    var _event = this.state.event;
    _event[e.target.name] = e.target.value;
    this.setState({event: _event})
  },

  render: function() {
    return(
        <form className="center-block">
          <div className="form-group">
            <label for="input_wedding_board_name">
              Name the wedding board
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
            <label for="input_wedding_board_name">
              What is your role in the wedding?
            </label>
            <select value="option3" id="input_event_role" name="role" onChange={this._onChangeInput} ref="select2">
              <option>option1</option>
              <option value="option3">option2</option>
              <option value="option3">option3</option>
            </select>
          </div>
          <div className="form-group">
            <label for="input_number_of_assistants">
              How many bridesmaids at the wedding
            </label>
            <input type="number"
                   className="form-control number-field js-number-field"
                   min="0"
                   id="input_number_of_assistants"
                   name="number_of_assistants"
                   ref="numberfield"
                   value={this.state.event.number_of_assistants}
                   onChange={this._onChangeInput} />
          </div>
          <div className="form-group">
            <label for="input_date">What is the date of the wedding?</label>
            <div className="input-group date date-picker">
              <input
                  type="text"
                  className="form-control"
                  placeholder="dd/mm/yyyy"
                  name="date"
                  ref="datepicker"
                  onChange={this._onChangeInput}/>
              <span className="input-group-addon">
                <i className="calendar-icon"></i>
              </span>
            </div>
          </div>
          <div className="form-group">
            <button className="btn-black center-block" onClick={this.handleUpdate}>Update</button>
          </div>
        </form>
    )
  }
});
