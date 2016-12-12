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
    var presentationName = this.props.componentName.split('-').join(' ');

    return (
      <div ref="container" className="customization-selector animated slideInLeft">
        <div className="selector-header">
          <i className={"icon icon-" + this.props.componentName}></i>
          <div className="selector-name text-left">{presentationName}</div>
          <div className="selector-close" onClick={this.close}></div>
        </div>
        <div className="selector-body">
          {this.renderCustomizationItem()}
        </div>
      </div>
    );
  }
});
