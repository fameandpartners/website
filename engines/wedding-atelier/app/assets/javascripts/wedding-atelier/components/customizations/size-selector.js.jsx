var SizeSelector = React.createClass({
  propTypes: {
    siteVersion: React.PropTypes.string,
    sizes: React.PropTypes.array,
    heights: React.PropTypes.array,
    assistants: React.PropTypes.array,
    selectCallback: React.PropTypes.func.isRequired,
    type: React.PropTypes.string
  },

  getInitialState: function(){
    return { assistantSelected: false }
  },

  componentDidMount: function(){
    $(this.refs.heightSelect)
      .select2({ minimumResultsForSearch: Infinity })
      .on('change', function(e){
        this.props.selectCallback('height', e.target.value);
        if(this.state.assistantSelected){
          $('input[name="assistant"]').removeProp('checked');
          // this following line is in order to reset if the menu shows the user name
          // or a size no
          this.props.selectCallback('size', { name: $('input[name="size"]:checked').val() });
          this.setState({assistantSelected: false});
        }
      }.bind(this));
  },

  parsePresentation: function(size){
    var regexp = new RegExp(this.props.siteVersion + '(\\d+)', 'i')
    return size.name.match(regexp)[1];
  },

  setSizeWithProfile: function(assistant){
    $(this.refs.container).find('input[value="' + assistant.user_profile.dress_size + '"]').prop('checked', true)
    $(this.refs.heightSelect).select2().val(assistant.user_profile.height).change();
    this.props.selectCallback('size', assistant);
    this.setState({assistantSelected: true});
  },

  changeSize: function(size){
    $('input[name="assistant"]').removeProp('checked');
    $(this.refs.heightSelect).select2()
    this.props.selectCallback('size', size);
  },

  render: function() {

    var optionsForHeights = this.props.heights.map(function(group){
      var heights = group[1].map(function(height, index){
        return(<option key={index} value={height}>{height}</option>)
      });

      return (
        <optgroup key={group[0]} label={group[0]}>
          {heights}
        </optgroup>
      )
    });

    var dressSizes = this.props.sizes.map(function(size, index){
      var id = this.props.type + '-size-' + index;
      return (
        <li key={index}>
          <input
            id={id}
            type="radio"
            name="size"
            value={size.name}
            onClick={this.changeSize.bind(null, size)}
             />
          <label htmlFor={id}>{this.parsePresentation(size)}</label>
        </li>
      )
    }.bind(this));

    var assistantsSizes = this.props.assistants.map(function(assistant, index){
      var id = this.props.type + '-assistant-' + index;

      return (
        <li key={index}>
          <input
            id={id}
            type="radio"
            name="assistant"
            value={assistant.user_profile.dress_size}
            onClick={this.setSizeWithProfile.bind(this, assistant)}
             />
          <label htmlFor={id}>{assistant.first_name}</label>
        </li>
      )
    }.bind(this));

    return (
      <div ref="container" className="customization-selector animated slideInLeft">
        <div className="customization customization-size">
          <div className="customization-title">
            <h1><em>Tailor</em> to your body</h1>
            <p className="description">Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
          </div>
          <div className="form-group">
            <label htmlFor="heightSelect" className="text-left">Whats your height</label>
            <div>
              <select id="heightSelect" ref="heightSelect" className="form-control">
                { optionsForHeights }
              </select>
            </div>
          </div>
          <div className="form-group">
            <label>Whats your dress size &nbsp;</label><a href="#" className="guide-link hover-link">view size guide</a>
            <div className="dress-sizes">
              <ul className="customization-dress-sizes-ul">
                {dressSizes}
              </ul>
            </div>
          </div>
          <div className="form-group">
            <label>use one of the bridal parties size profiles</label>
            <div className="dress-sizes assistants-sizes">
              <ul className="customization-dress-sizes-ul people">
                {assistantsSizes}
              </ul>
            </div>
          </div>
        </div>
      </div>
    );
  }
});
