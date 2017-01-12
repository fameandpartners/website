var FabricAndColourSelector = React.createClass({
  propTypes: {
    colours: React.PropTypes.array,
    fabrics: React.PropTypes.array,
    selectCallback: React.PropTypes.func.isRequired,
    currentCustomization: React.PropTypes.string
  },

  getInitialState: function() {
    return {
      selectedFabric: null,
      selectedColour: null
    };
  },

  componentWillReceiveProps: function(nextProps){
    if(!this.state.selectedFabric && !this.state.selectedColour){
      var newState = {
        selectedFabric: _.findWhere(nextProps.fabrics, { name: 'HG'}),
        selectedColour: _.findWhere(nextProps.colours, { name: 'berry'})
      }
      this.setState(newState);
    }
  },

  fabricSelectedHandle: function(fabric) {
    var newState = $.extend({}, this.state);
    newState.selectedFabric = fabric;
    this.setState(newState, function(){
      this.props.selectCallback('fabric', fabric);
      if(!this.state.selectedColour){
        this.colourSelectedHandle(this.props.colours[0]);
      }
    }.bind(this));
  },

  colourSelectedHandle: function(colour) {
    if(this.state.selectedFabric) {
      var newState = $.extend({}, this.state);
      newState.selectedColour = colour;
      this.setState(newState, function(){
        if(this.state.selectedFabric){
          this.props.selectCallback('colour', colour);
        }
      }.bind(this));
    }
  },

  renderFabrics: function () {
    var that = this;
    return this.props.fabrics.map(function(fabric, index) {
      var inputId = fabric.id + "-" + 'desktop',
          isChecked = fabric === that.state.selectedFabric;

      return (
        <div key={inputId} onClick={that.fabricSelectedHandle.bind(null, fabric)} className="fabric-radio-container">
          <input id={inputId} type="radio" defaultChecked={isChecked} value={fabric} name="fabric" className="customization-radio"/>
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
      var classes = classNames({
        'customization-options-item-small': true,
        'active': that.state.selectedColour && that.state.selectedColour.id == colour.id,
        'disabled': !that.state.selectedFabric
      });

      var inputId = colour.id + "-" + 'desktop';
      return (
        <div key={inputId} onClick={that.colourSelectedHandle.bind(null, colour)} className="col-sm-4 col-md-3">
          <div className={classes} style={{backgroundColor: colour.value}}></div>
          <p className="customization-options-item-label">{colour.presentation}</p>
        </div>
      );
    });

  },

  render: function() {
    var customizationSelectorClasses = classNames({
      'customization-selector': true,
      'animated': true,
      'slideInLeft': this.props.showContainers.showSelector,
      'active': this.props.currentCustomization === 'fabric-color'
    });

    return (
      <div ref="container" className={customizationSelectorClasses}>
        <div className="customization">
          <div className="customization-title">
            <h1><em>Create</em> the look and feel.</h1>
            <div className="row">{this.renderFabrics()}</div>
            <p className="description">Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
          </div>
          <div className="customization-options-grid row">
            {this.renderColours()}
          </div>
         </div>
      </div>
    );
  }
});
