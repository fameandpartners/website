var FabricAndColourSelector = React.createClass({
  propTypes: {
    colours:          React.PropTypes.array,
    fabrics:          React.PropTypes.array,
    selectedOption:   React.PropTypes.object,
    selectCallback:   React.PropTypes.func.isRequired,
    showContainers:   React.PropTypes.object
  },

  selectFabric: function(fabric) {
    this.props.selectCallback('fabric', fabric);
  },

  render: function() {
    var fabrics = this.props.fabrics.map(function(fabric, index) {
      var inputId = fabric.id + "-" + 'desktop';

      return (
        <div key={inputId} onClick={this.selectFabric.bind(this, fabric)} className="fabric-radio-container">
          <input id={inputId} type="radio" value={fabric} name="fabric" className="customization-radio"/>
          <label htmlFor={inputId} className="customization-radio-label">
            <span className="box"></span>
            <span className="real-label">{fabric.presentation}</span>
          </label>
        </div>
      );
    }.bind(this));

    var colours = this.props.colours.map(function(colour, index) {
      var classes = classNames({
        'customization-options-item-small': true,
        'active': this.props.selectedOption && this.props.selectedOption.id == colour.id
      });
      var inputId = colour.id + "-" + 'desktop';
      return (
        <div key={inputId} onClick={this.props.selectCallback.bind(null, 'colour', colour)} className="col-sm-4 col-md-3">
          <div className={classes} style={{backgroundColor: colour.value}}></div>
          <p className="customization-options-item-label">{colour.presentation}</p>
        </div>
      );
    }.bind(this));

    var customizationSelectorClasses = classNames({
      'customization-selector': true,
      'animated': true,
      'slideInLeft': this.props.showContainers.showSelector,
      'active': this.props.currentCustomization === 'fabric-colour'
    });

    return (
      <div ref="container" className={customizationSelectorClasses}>
        <div className="customization">
          <div className="customization-title">
            <h1><em>Create</em> the look and feel</h1>
            <div className="row">{fabrics}</div>
            <p className="description">Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
          </div>
          <div className="customization-options-grid row">
            {colours}
          </div>
         </div>
      </div>
    );
  }
});
