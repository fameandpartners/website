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
        height: this.refs.profile_height.value,
        dress_size_id: this.refs.profile_dress_size_id.value,
      }
    }

    this.props.saveValues(data);

    if (this.props.newEvent) {
      this.props.saveValues({ wedding_atelier_signup_step: 'completed' });
      this.props.submitEvent();
    } else {
      this.props.nextStep();
    }
  },

  render: function() {
    var that = this;
    var index = 1;

    var optionsForHeights = this.props.heights.map(function(group) {
      var heights = group[1].map(function(height, index){
        return(<option key={index} value={height}>{height}</option>);
      });

      return (
        <optgroup key={group[0]} label={group[0]}>
          {heights}
        </optgroup>
      );
    });

    var dressSizes = this.props.sizes.map(function(sizes) {
      var sizesGroup = sizes.map(function(value){
        var size = value.option_value,
          id = "dress-size-" + index,
          inputProps = {
            id: id,
            type: "radio",
            ref: "profile_dress_size_id",
            value: size.id
          };

        index += 1;
        return (
          <li key={index} className="dress-size">
          <input {...inputProps} />
          <label htmlFor={id}>{PresentationHelper.sizePresentation(size, that.props.siteVersion)}</label>
          </li>
        );
      });

      return (
        <div className="sizing-row">{sizesGroup}</div>
      );
    });

    return (
      <div className="registrations__size-form signup left-side-centered-container">
        <h1 className="text-center">Let's get your size profile</h1>
        <div className="form">

          <div className="form-group">
            <label>What's Your Height?</label>
            <div>
              <select className="form-control" id="spree_user_user_profile_attributes_height" ref="profile_height">
                {optionsForHeights}
              </select>
            </div>
          </div>

          <div className="form-group">
            <label>DRESS SIZE </label>
            <SizeGuideModalLauncher className='size-guide-modal-launcher-container' />

            <div className="dress-sizes">
              <ul>
                {dressSizes}
              </ul>
            </div>

          </div>
        </div>
        <input className="btn btn-black full-width" defaultValue="next" onClick={this.nextStep} type="button" />
      </div>
    );
  }
});


