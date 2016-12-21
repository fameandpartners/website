var FabricAndColourSelectorMobile = React.createClass({
  propTypes: {
    colours:                React.PropTypes.array,
    fabrics:                React.PropTypes.array,
    selectedOption:         React.PropTypes.object,
    selectCallback:         React.PropTypes.func.isRequired,
    selectOptionCallback:   React.PropTypes.func.isRequired
  },

  render: function() {
    var fabrics = this.props.fabrics.map(function(fabric, index) {
      var inputId = fabric.id + "-" + 'mobile';

      return (
        <div key={inputId} onClick={this.props.selectOptionCallback.bind(null, 'fabric', fabric)} className="fabric-radio-container">
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
        'customizations-selector-mobile-options-item-small': true,
        'active': this.props.selectedOption && this.props.selectedOption.id == colour.id
      });
      var inputId = colour.id + "-" + 'mobile';
      return (
        <div key={inputId} onClick={this.props.selectOptionCallback.bind(null, 'colour', colour)} className="col-xs-6">
          <div className={classes} style={{backgroundColor: colour.value}}>
          </div>
          <p className="customizations-selector-mobile-options-item-label">{colour.presentation}</p>
        </div>
      );
    }.bind(this));

    return (
      <div ref="container" className="customizations-selector-mobile">
        <div className="customizations-selector-mobile-title">
          <h1><em>Create</em> it how you want</h1>
          <div className="row">
            {fabrics}
          </div>
          <p className="description">Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
        </div>
        <div className="customizations-selector-mobile-grid row">
          {colours}
        </div>
      </div>
    );
  }
});
