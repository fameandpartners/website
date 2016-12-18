var CustomizationsHeader = React.createClass({
  propTypes: {
    silhouette: React.PropTypes.object
  },

  render: function(){
    var designName = '';
    if(this.props.silhouette){
      designName = 'You are designing the ' + this.props.silhouette.name;
    }
    return(
      <div className="customization-experience-header">
        <div className="col-sm-6 arrow">
          <a href="#" className="back-to-moodboard">
            Back to wedding moodboard
          </a>
        </div>
        <div className="col-sm-6">
          <span className="design-name">{designName}</span>
        </div>
      </div>
    );
  }
});
