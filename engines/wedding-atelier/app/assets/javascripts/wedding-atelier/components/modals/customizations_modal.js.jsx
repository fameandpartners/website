var CustomizationsModal = React.createClass({
  propTypes: {
    selectedOptions: React.PropTypes.object,
    siteVersion: React.PropTypes.string,
    editDesignCallback: React.PropTypes.func
  },

  presentationFor: function(customization){
    return PresentationHelper.presentation(this.props.selectedOptions, customization, this.props.siteVersion) || '-';
  },

  render: function(){
    return (
      <div className="modal modal-customizations fade" ref="modal" id="modal-customizations" tabIndex="-1" role="dialog">
        <div className="modal-vertical-align-helper">
          <div className="modal-dialog modal-vertical-align" role="document">
            <div className="modal-content">
              <div className="modal-body">
                <div className="close-modal pull-right" data-dismiss="modal" aria-label="Close"></div>
                <div className="modal-body-container text-center">
                  <h1>
                    <em>What </em>
                    you customized.
                  </h1>
                  <div className="customization-list">
                    <ul>
                      <li>
                        <p className="customization-list-label">silhouette</p>
                        <p className="customization-list-value">{this.presentationFor('silhouette')}</p>
                      </li>
                      <li>
                        <p className="customization-list-label">fabric and color</p>
                        <p className="customization-list-value">{this.presentationFor('fabric-color')}</p>
                      </li>
                      <li>
                        <p className="customization-list-label">length</p>
                        <p className="customization-list-value">{this.presentationFor('length')}</p>
                      </li>
                      <li>
                        <p className="customization-list-label">style</p>
                        <p className="customization-list-value">{this.presentationFor('style')}</p>
                      </li>
                      <li>
                        <p className="customization-list-label">fit</p>
                        <p className="customization-list-value">{this.presentationFor('fit')}</p>
                      </li>
                      <li>
                        <p className="customization-list-label">size profile</p>
                        <p className="customization-list-value">{this.presentationFor('size')}</p>
                      </li>
                    </ul>
                  </div>
                </div>
              </div>
              <div className="modal-footer">
                <div className="action-buttons">
                  <button className="btn btn-transparent-inverse" onClick={this.props.editDesignCallback} data-dismiss="modal" aria-label="Close">Make Changes</button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
});
