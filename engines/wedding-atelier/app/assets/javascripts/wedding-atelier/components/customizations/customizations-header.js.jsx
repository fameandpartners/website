var CustomizationsHeader = React.createClass({
  propTypes: {
    silhouette: React.PropTypes.object,
    event_path: React.PropTypes.string,
    event_name: React.PropTypes.string
  },

  render: function() {
    var designName = '';
    if(this.props.silhouette){
      designName = 'You are designing the ' + this.props.silhouette.name + '.';
    }
    return(
      <div className="customization-experience-header">
        <div className="col-sm-6 col-xs-12 arrow">
          <a href={this.props.event_path} className="back-to-moodboard hidden-xs">
            Back to {this.props.event_name} board
          </a>
          <img src="/assets/fp-logo.svg" className="logo hidden-sm hidden-md hidden-lg"/>
        </div>
        <div className="col-sm-6" hidden-xs>
          <span className="design-name">{designName}</span>
        </div>
      </div>
    );
  }
});
