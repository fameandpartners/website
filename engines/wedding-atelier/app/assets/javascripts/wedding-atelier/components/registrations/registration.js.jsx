var Registration = React.createClass({
  propTypes: {
    fieldValues: React.PropTypes.object,
    signupPath: React.PropTypes.string.isRequired,
    userPath: React.PropTypes.string.isRequired,
    signinPath: React.PropTypes.string.isRequired,
    siteVersion: React.PropTypes.string,
    heightDefinitions: React.PropTypes.array,
    dressSizes: React.PropTypes.array
  },

  componentDidMount: function() {
    $(ReactDOM.findDOMNode(this)).modal({ backdrop: 'static', keyboard: false });
  },

  getInitialState: function() {
    return {
      step: 1,
      fieldValues: {}
    }
  },

  saveValues: function(newValues) {
    var _state = $.extend({}, this.state);
    $.extend(true, _state.fieldValues, newValues);
    this.setState(_state);
  },

  nextStep: function() {
    this.setState({
      step : this.state.step + 1
    })
  },

  previousStep: function() {
    this.setState({
      step : this.state.step - 1
    })
  },

  submitRegistration: function() {
    var payload = { spree_user: $.extend({}, this.state.fieldValues) };

    $.ajax({
      url: this.props.signupPath,
      type: 'POST',
      dataType: 'json',
      data: payload,
      success: function (response) {
        window.location = "/wedding-atelier/events/" + response.event.id + "/dresses/new";
      },
      error: function (data) {
        console.log('error');
      }
    });
  },

  submitEvent: function() {
    var payload = { spree_user: $.extend({}, this.state.fieldValues) };

    $.ajax({
      url:  this.props.userPath,
      type: 'PUT',
      dataType: 'json',
      data: payload,
      success: function (response) {
        debugger
        window.location = "/wedding-atelier/events/" + response.event.id
      }
    })
  },

  showStep: function() {
    switch (this.state.step) {
      case 1:
        return <EventFields fieldValues={this.props.fieldValues}
                            nextStep={this.nextStep}
                            previousStep={this.previousStep}
                            saveValues={this.saveValues} />
      case 2:
        return <SizeFields fieldValues={this.props.fieldValues}
                           nextStep={this.nextStep}
                           submitEvent={this.submitEvent}
                           previousStep={this.previousStep}
                           saveValues={this.saveValues}
                           heights={this.props.heightDefinitions}
                           sizes={this.props.dressSizes}
                           siteVersion={this.props.siteVersion} />
      case 3:
        return <UserFields fieldValues={this.props.fieldValues}
                           previousStep={this.previousStep}
                           saveValues={this.saveValues}
                           submitRegistration={this.submitRegistration} />
    }
  },

  render: function() {
    return (
      <div className="modal">
        <div className="modal-dialog modal-sm">
          <div className="modal-content">
            <div className="modal-header registrations__header">
              {this.state.step > 1 &&
                <a className='registrations__back-arrow' onClick={this.previousStep}></a>
              }
            </div>
            <div className="modal-body">
              <form action="/wedding-atelier/signup" className="new_spree_user">
                {this.showStep()}
              </form>
            </div>
            <div className="modal-footer registrations__footer">
              <p className="already-member text-center">
                Already a member?&nbsp;
                <a className="bold hover=link" href={this.props.signinPath}>log in here</a>
              </p>
            </div>
          </div>
        </div>
      </div>
    );
  }
});

