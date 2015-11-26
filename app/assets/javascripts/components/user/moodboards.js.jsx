// see helpers.UserMoodboard
// app/assets/javascripts/partials/helpers/user_moodboard.js.coffee
var MoodboardItemCount = React.createClass({
  getInitialState: function(){
    return { count: this.props.count || 0 };
  },

  componentDidMount: function(){
    window.app.user_moodboard.on('change', this.handleChange);
  },

  handleChange: function(_ev){
    this.setState({
      // TODO - Remove the hard coded thingo & use event data.
      count: window.app.user_moodboard.itemCount()
    })
  },

  render: function(){
    return(
      <a href={this.props.moodboard_link}>
        <span className="copy">{this.state.count}</span>
        <span className="icon icon-heart"></span>
      </a>
    );
  }
});
