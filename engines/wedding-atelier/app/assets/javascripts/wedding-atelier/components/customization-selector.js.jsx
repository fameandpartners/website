var CustomizationSelector = React.createClass({
  propTypes: {
    selectCallback: React.PropTypes.func.isRequired,
    componentName: React.PropTypes.string.isRequired
  },

  renderCustomizationItem: function () {
    switch (this.props.componentName) {
      case 'silhouette':
        return (
          <CustomizeSilhouette
            componentName={this.props.componentName}
            selectCallback={this.props.selectCallback}
            dresses={this.props.dresses}
            />
        );
      case 'fabric-colour':
        return (
          <CustomizeFabricColour
            componentName={this.props.componentName}
            selectCallback={this.props.selectCallback}
            dresses={this.props.dresses}
            />
        );
      case 'length':
        return (
          <CustomizeLength
            componentName={this.props.componentName}
            selectCallback={this.props.selectCallback}
            dresses={this.props.dresses}
            />
        );
      case 'style':
        return (
          <CustomizeStyle
            componentName={this.props.componentName}
            selectCallback={this.props.selectCallback}
            dresses={this.props.dresses}
            />
        );
      case 'fit':
        return (
          <CustomizeFit
            componentName={this.props.componentName}
            selectCallback={this.props.selectCallback}
            dresses={this.props.dresses}
            />
        );
      case 'size':
        return (
          <CustomizeSize
            componentName={this.props.componentName}
            selectCallback={this.props.selectCallback}
            dresses={this.props.dresses}
            />
        );
      default:
        return <h1>Hello</h1>;
    }
  },

  close: function() {
    $(this.refs.container).hide();
  },

  render: function() {
    return (
      <div ref="container" className="customization-selector animated slideInLeft">
        <div className="selector-header">
          <span className="close" onClick={this.close}>x</span>
        </div>
        { this.renderCustomizationItem() }
      </div>
    );
  }
});
