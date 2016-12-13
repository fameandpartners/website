var CustomizationSelector = React.createClass({
  propTypes: {
    type: React.PropTypes.string,
    options: React.PropTypes.array,
    keyword: React.PropTypes.string,
    title: React.PropTypes.string,
    description: React.PropTypes.string,
    selectCallback: React.PropTypes.func.isRequired
  },


  close: function() {
    $(this.refs.container).hide();
  },

  render: function() {
    var options = this.props.options.map(function(option, index) {
      return (
        <div key={index} onClick={ this.props.selectCallback.bind(null, this.props.type, option) } className="col-sm-6 col-md-4">
          <div className="customization-options-item">{ option }</div>
        </div>
      );
    }.bind(this));

    return (
      <div ref="container" className="customization-selector animated slideInLeft">
        <div className="selector-header">
          <i className={"icon icon-" + this.props.type}></i>
          <div className="selector-name text-left">{this.props.type}</div>
          <div className="selector-close" onClick={this.close}></div>
        </div>
        <div className="selector-body">
          <div className="customization">
            <div className="customization-title">
              <h1><em>{this.props.keyword}</em> {this.props.title}</h1>
              <p className="description">{this.props.description}</p>
            </div>
            <div className="customization-options-grid row">
              { options }
            </div>
         </div>
        </div>
      </div>
    );
  }
});
