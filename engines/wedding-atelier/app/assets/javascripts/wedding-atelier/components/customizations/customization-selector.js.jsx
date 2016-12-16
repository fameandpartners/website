var CustomizationSelector = React.createClass({
  propTypes: {
    type: React.PropTypes.string,
    options: React.PropTypes.array,
    selectedOption: React.PropTypes.object,
    keyword: React.PropTypes.string,
    title: React.PropTypes.string,
    description: React.PropTypes.string,
    selectCallback: React.PropTypes.func.isRequired
  },

  isOptionSelected: function(option){
    var selectedOption = this.props.selectedOption;
    return selectedOption && selectedOption.id == option.id;
  },

  render: function() {
    var options = this.props.options.map(function(option, index) {
      var classes = classNames({
        'customization-options-item': true,
        active: this.isOptionSelected(option)
      })
      var customizationClass = 'customization-options-item';
      return (
        <div key={index} onClick={ this.props.selectCallback.bind(null, this.props.type, option) } className="col-sm-6 col-md-6 col-lg-4">
          <div className={classes}>
            <img src={option.image} />
            <p>{option.name}</p>
          </div>
        </div>
      );
    }.bind(this));

    return (
      <div ref="container" className="customization-selector animated slideInLeft">
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
    );
  }
});
