var CustomizationsHeader = React.createClass({
  propTypes: {
    silhouette: React.PropTypes.object,
    event_path: React.PropTypes.string,
    event_name: React.PropTypes.string,
    bagOpenedCallback: React.PropTypes.func,
    event_name: React.PropTypes.string,
    savedDress: React.PropTypes.bool
  },

  backToMoodboard: function(e){
    if(!this.props.savedDress){
      e.preventDefault();
      $('.js-save-dress-before-leave-modal').modal();
    }
  },

  render: function() {
    var designName = '';
    if(this.props.silhouette) {
      designName = 'You are designing The ' + this.props.silhouette.name + '.';
    }

    return(
      <div className="customization-experience-header">
        <a href={this.props.event_path} onClick={this.backToMoodboard} className="customization-experience-header-back-arrow">
          <div className="going-back-wrapper">
            <img src="/assets/lessthan.svg" />
            <span className="hidden-xs">{'Back to ' + this.props.event_name}</span>
          </div>
        </a>
        <div className="customization-experience-header-logo hidden-sm hidden-md hidden-lg"></div>
        <div className="customization-experience-header-actions">
          <div className="customization-experience-header-dress-name hidden-xs hiden-sm">{designName}</div>
          <div className="customization-experience-header-help hidden-xs"></div>
          <ShoppingBag className="shopping-bag" openedCallback={this.props.bagOpenedCallback}/>
        </div>
      </div>
    );
  }
});
