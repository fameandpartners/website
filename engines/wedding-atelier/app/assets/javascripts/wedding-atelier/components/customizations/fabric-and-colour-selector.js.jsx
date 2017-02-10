var FabricAndColorSelector = React.createClass({
  propTypes: {
    colors: React.PropTypes.array,
    fabrics: React.PropTypes.array,
    selectedOptions: React.PropTypes.object,
    selectCallback: React.PropTypes.func.isRequired,
    currentCustomization: React.PropTypes.string,
  },

  getInitialState: function() {
    return {
      selectedFabric: null,
      selectedColor: null
    };
  },

  componentWillReceiveProps: function(nextProps) {
    if(this.props.selectedOptions.silhouette) {
      var silhouetteChanged = this.props.selectedOptions.silhouette.id !== nextProps.selectedOptions.silhouette.id;
    }

    if(!this.state.selectedFabric && !this.state.selectedColor || silhouetteChanged) {
      var newState = {
        selectedFabric: nextProps.selectedOptions.fabric,
        selectedColor: nextProps.selectedOptions.color
      };
      this.setState(newState);
    }
  },

  fabricSelectedHandle: function(fabric) {
    var newState = $.extend({}, this.state);
    newState.selectedFabric = fabric;
    this.setState(newState, function(){
      this.props.selectCallback('fabric', fabric);
      if(!this.state.selectedColor){
        this.colorSelectedHandle(this.props.colors[0]);
      }
    }.bind(this));
  },

  colorSelectedHandle: function(color) {
    if(this.state.selectedFabric) {
      var newState = $.extend({}, this.state);
      newState.selectedColor = color;
      this.setState(newState, function(){
        if(this.state.selectedFabric){
          this.props.selectCallback('color', color);
        }
      }.bind(this));
    }
  },

  renderFabrics: function () {
    var that = this;
    return this.props.fabrics.map(function(fabric, index) {
      var inputId = fabric.id + "-" + 'desktop',
          isChecked = fabric.id === that.state.selectedFabric.id;

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

  renderColors: function () {
    var that = this;
    return this.props.colors.map(function(color, index) {
      var classes = classNames({
        'customization-options-item-small': true,
        'active': that.state.selectedColor && that.state.selectedColor.id == color.id,
        'disabled': !that.state.selectedFabric
      });

      var inputId = color.id + "-" + 'desktop';
      return (
        <div key={inputId} onClick={that.colorSelectedHandle.bind(null, color)} className="col-sm-4 col-md-3">
          <div className={classes} style={{backgroundColor: color.value}}></div>
          <p className="customization-options-item-label">{color.presentation}</p>
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
            <p className="description">Heavy georgette has a flat, matte finish. Matte satin has a little more shine. Which do you prefer?</p>
          </div>
          <div className="customization-options-grid row">
            {this.renderColors()}
          </div>
         </div>
      </div>
    );
  }
});
