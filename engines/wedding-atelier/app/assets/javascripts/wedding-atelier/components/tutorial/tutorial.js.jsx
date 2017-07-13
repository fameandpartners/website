var Tutorial = React.createClass({
  propTypes: {
    signupStep: React.PropTypes.string,
    userPath: React.PropTypes.string
  },

  componentDidMount: function() {
    if (this.props.signupStep != 'completed') {
      $(ReactDOM.findDOMNode(this)).modal({ backdrop: 'static', keyboard: false });
    };
  },

  getInitialState: function() {
    return {
      step: 1,
      fieldValues: {}
    }
  },

  finishTutorial: function() {
    var modal = $(ReactDOM.findDOMNode(this));
    var payload = { spree_user: { wedding_atelier_signup_step: 'completed' } };
    var that = this;
    $.ajax({
      url: this.props.userPath,
      type: 'PUT',
      dataType: 'json',
      data: payload,
      success: function (response) {
        modal.modal('toggle');
      },
      error: function (data) {
        that.refs.notifications.notify(JSON.parse(data.responseText).errors);
      }
    });
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

  showStep: function() {
    switch (this.state.step) {
      case 1:
        return <TutorialStep1 nextStep={this.nextStep}
                              previousStep={this.previousStep} />
      case 2:
        return <TutorialStep2 nextStep={this.nextStep}
                              previousStep={this.previousStep} />
      case 3:
        return <TutorialStep3 nextStep={this.nextStep}
                              previousStep={this.previousStep}
                              finishTutorial={this.finishTutorial} />
    }
  },


  render: function() {
    return (
      <div className="modal vertically-centered">
        <Notification ref="notifications"/>
        <div className="modal-dialog modal-sm">
          <div className="modal-content">
            <div className="modal-header registrations__header">
              {this.state.step > 1 &&
                <a className='registrations__back-arrow' onClick={this.previousStep}></a>
              }
            </div>
            <div className="modal-body">
              {this.showStep()}
            </div>
          </div>
        </div>
      </div>
    );
  }
});
