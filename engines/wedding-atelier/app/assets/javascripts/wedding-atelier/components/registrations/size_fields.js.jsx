var SizeFields = React.createClass({
  componentDidMount: function() {
    $('#spree_user_user_profile_attributes_height').select2({
      placeholder: 'Please select your height',
      minimumResultsForSearch: Infinity
    });
  },

  nextStep: function(e) {
    e.preventDefault();

    var data = {
      user_profile_attributes: {
        height: this.refs["profile.height"].value,
        dress_size_id: this.refs["profile.dress_size_id"].value,
      }
    }

    this.props.saveValues(data)
    this.props.nextStep()
  },

  render: function() {
    return (
      <div className="registrations__size-form signup left-side-centered-container">
        <h1 className="text-center">Let's get your size profile</h1>
        <div className="form">

          <div className="form-group">
            <label>What's Your Height?</label>
            <div>
              <select className="form-control" id="spree_user_user_profile_attributes_height" ref="profile.height">
                <optgroup label="petite">
                  <option value="4'10&quot;/147cm">4'10/147cm</option>
                  </optgroup>
              </select>
            </div>
          </div>

          <div className="form-group">
            <label>DRESS SIZE </label>
            <SizeGuideModalLauncher className='size-guide-modal-launcher-container' />

            <div className="dress-sizes">
              <ul>
                <div className="sizing-row">
                  <li className="dress-size">
                    <input id="spree_user_user_profile_attributes_dress_size_id_86" ref="profile.dress_size_id" type="radio" value="86" />
                    <label htmlFor="spree_user_user_profile_attributes_dress_size_id_86">US 0</label>
                  </li>
                </div>
              </ul>
            </div>

          </div>
        </div>
        <input className="btn btn-black full-width" defaultValue="next" onClick={this.nextStep} type="button" />
      </div>
    );
  }
});


