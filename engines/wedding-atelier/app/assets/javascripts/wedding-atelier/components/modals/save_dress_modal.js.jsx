var SaveDressModal = React.createClass({
  propTypes: {
    eventSlug: React.PropTypes.string
  },
  newDress: function(){
    location.reload()
  },

  render: function(){
    var moodboardUrl = '/wedding-atelier/events/' + this.props.eventSlug;
    return(
      <div className="js-save-dress-modal modal modal-confirm fade" id="modal-confirm" tabIndex='-1' role='dialog'>
        <div className="modal-vertical-align-helper">
          <div className="modal-dialog modal-vertical-align" role='document'>
            <div className="modal-content">
              <div className="modal-body">
                <div className="close-modal pull-right" data-dismiss="modal" aria-label="Close"></div>
                <div className="modal-body-container text-center">
                  <h1>
                    Saved!
                  </h1>
                  <div className="action-buttons">
                    <a href={moodboardUrl} className="btn-white" type='button'> Back to moodboard </a>
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
