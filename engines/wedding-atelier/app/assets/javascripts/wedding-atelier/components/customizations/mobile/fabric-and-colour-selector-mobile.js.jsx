var FabricAndColourSelectorMobile = React.createClass({
  propTypes: {
    colours: React.PropTypes.array,
    fabrics: React.PropTypes.array,
    selectedOptions: React.PropTypes.object,
    selectCallback: React.PropTypes.func.isRequired,
    currentCustomization: React.PropTypes.string,
    selectOptionCallback: React.PropTypes.func.isRequired
  },

  getInitialState: function () {
    return {
      selectedFabric: null,
      selectedColour: null
    }
  },

  componentWillReceiveProps: function(nextProps){
    if(!this.state.selectedFabric && !this.state.selectedColour){
      var newState = {
        selectedFabric: nextProps.selectedOptions.fabric,
        selectedColour: nextProps.selectedOptions.colour
      }
      this.setState(newState);
    }
  },

  fabricSelectedHandle: function (fabric) {
    this.setState({selectedFabric: fabric});
    this.props.selectOptionCallback('fabric', fabric);
    if(this.props.colours[0] && !this.state.selectedColour) {
      this.setState({selectedColour: this.props.colours[0]});
    }
  },

  colourSelectedHandle: function (colour) {
    if(this.state.selectedFabric) {
      this.setState({selectedColour: colour});
      this.props.selectOptionCallback('colour', colour);
    }
  },

  renderFabrics: function () {
    var that = this;
    return this.props.fabrics.map(function(fabric, index) {
      var inputId = fabric.id + "-" + 'mobile',
          isChecked = fabric.id === that.state.selectedFabric.id;
      return (
        <div key={inputId} onClick={that.fabricSelectedHandle.bind(null, fabric)} className="fabric-radio-container">
          <input id={inputId} type="radio" checked={isChecked} value={fabric} name="fabric" className="customization-radio"/>
          <label htmlFor={inputId} className="customization-radio-label">
            <span className="box"></span>
            <span className="real-label">{fabric.presentation}</span>
          </label>
        </div>
      );
    });
  },

  renderColours: function () {
    var that = this;
    return this.props.colours.map(function(colour, index) {
      var inputId = colour.id + "-" + 'mobile';
      var classes = classNames({
        'customizations-selector-mobile-options-item-small': true,
        'active': that.state.selectedColour && that.state.selectedColour.id === colour.id
      });

      return (
        <div key={inputId} onClick={that.colourSelectedHandle.bind(null, colour)} className="col-xs-6">
          <div className={classes} style={{backgroundColor: colour.value}}></div>
          <p className="customizations-selector-mobile-options-item-label">{colour.presentation}</p>
        </div>
      );
    });
  },

  render: function() {

    var containerClasses = classNames({
      'customizations-selector-mobile': true,
      'active': this.props.currentCustomization === 'fabric-color'
    });

    return (
      <div ref="container" className={containerClasses}>
        <div className="customizations-selector-mobile-title">
          <h1><em>Create</em> it how you want</h1>
          <div className="row">
            {this.renderFabrics()}
          </div>
          <p className="description">Heavy georgette has a flat, matte finish. Matte satin has a little more shine. Which do you prefer?</p>
        </div>
        <div className="customizations-selector-mobile-grid row">
          {this.renderColours()}
        </div>
      </div>
    );
  }
});
