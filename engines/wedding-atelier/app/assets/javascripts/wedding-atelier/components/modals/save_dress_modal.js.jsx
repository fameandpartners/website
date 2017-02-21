var SaveDressModal = React.createClass({
  propTypes: {
    eventPath: React.PropTypes.string
  },
  newDress: function(){
    location.reload()
  },

  render: function(){
    return(
      <div className="js-save-dress-modal modal save-dress-modal fade" id="modal-confirm" tabIndex='-1' role='dialog'>
        <div className="modal-vertical-align-helper">
          <div className="modal-dialog modal-vertical-align" role='document'>
            <div className="modal-content">
              <div className="modal-body">
                <div className="close-modal pull-right" data-dismiss="modal" aria-label="Close"></div>
                <div className="modal-body-container center-vertical text-center">
                  <h1>
                    Your dress has been saved!
                  </h1>
                  <div className="action-buttons">
                    <a href={this.props.eventPath} className="btn-white" type='button'> Back to moodboard </a>
                    <a href="#" onClick={this.newDress} className="btn-black" type='button'> create another dress </a>
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
