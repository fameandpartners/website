var SaveDressBeforeLeaveModal = React.createClass({
  propTypes: {
    eventId: React.PropTypes.number,
    selectedOptions: React.PropTypes.object,
    edit: React.PropTypes.bool,
    initialDress: React.PropTypes.object,
    currentUser: React.PropTypes.object,
    savedDressCallback: React.PropTypes.func,
    eventPath: React.PropTypes.string
  },

  savedDressCallback: function() {
    this.props.savedDressCallback();
    window.location = this.props.eventPath;
  },

  render: function(){
    return(
      <div className="js-save-dress-before-leave-modal modal save-dress-modal fade" tabIndex='-1' role='dialog'>
        <div className="modal-vertical-align-helper">
          <div className="modal-dialog modal-vertical-align" role='document'>
            <div className="modal-content">
              <div className="modal-body">
                <div className="close-modal pull-right" data-dismiss="modal" aria-label="Close"></div>
                <div className="modal-body-container center-vertical text-center">
                  <h1>
                    <em>Would you</em> like to save this dress customization to the wedding moodboard?
                  </h1>
                  <div className="action-buttons row">
                    <a href={this.props.eventPath} className="btn-white hidden-xs" type='button'> Don't save </a>
                    <SaveDressButton
                      eventId={this.props.eventId}
                      selectedOptions={this.props.selectedOptions}
                      buttonClass='btn-black save-dress-button col-xs-offset-1 col-xs-10'
                      edit={this.props.edit}
                      initialDress={this.props.initialDress}
                      currentUser={this.props.currentUser}
                      savedDressCallback={this.savedDressCallback}
                      caption="Save the dress"
                      showSavedModal={false}
                      />
                      <a href={this.props.eventPath} className="btn-white visible-xs col-xs-offset-1 col-xs-10" type='button'> Don't save </a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }
})
