// see helpers.UserMoodboard
// app/assets/javascripts/partials/helpers/user_moodboard.js.coffee
var MoodboardItemCount = React.createClass({
  getInitialState: function(){
    return { count: this.props.count || 0 };
  },

  componentDidMount: function(){
    window.app.user_moodboards.on('change', this.handleChange);
  },

  handleChange: function(_ev){
    this.setState({
      // TODO - Remove the hard coded thingo & use event data.
      count: window.app.user_moodboards.default().items.length
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

var AddToMoodboard = React.createClass({
  getInitialState: function() {
    return { alreadyOnBoard: false };
  },

  componentDidMount: function(){
    window.app.user_moodboards.on('change', this.handleChange);
  },

  item: function(){
    return {
      moodboard_id: this.props.moodboard.id,
      product_id:   this.props.product_id,
      color_id:     this.props.color_id
    };
  },

  handleChange: function(_ev){
    var hasItem = window.app.user_moodboards.hasItem(this.item());

    this.setState({ alreadyOnBoard: hasItem });
  },

  addHandler: function(_args){
    window.app.user_moodboards.addItem(this.item());
  },

  render: function(){
    if (this.state.alreadyOnBoard) {
      return(<OnMoodboard key={this.props.moodboard.id} moodboard_name={this.props.moodboard.name} />);
    } else {
      return(<AddToMoodboardTrigger key={this.props.moodboard.id} moodboard_name={this.props.moodboard.name} addHandler={this.addHandler} />);
    }
  }

});

var OnMoodboard = React.createClass({
  render: function(){
    return(<span>On {this.props.moodboard_name}</span>)
  }
});

var AddToMoodboardTrigger = React.createClass({

  getInitialState : function(){
    return { clicked: false };
  },
  handleClick: function (_event) {
    this.setState({clicked:true});
    this.props.addHandler();
  },

  render: function(){

    var action = "+ Add";

    if (this.state.clicked == true) {
      action = "⟳ Adding";
    }
    return (<span onClick={this.handleClick}>{action} to {this.props.moodboard_name}</span>);
  }
});

// Used to bridge between Embedded coffeescript templates and new react components
// When adding new content via ajax, the templates are rendered, and we want to add
// the React components, but the call happens before the template DOM is attached to
// the page, so we need to defer the React.render and retry.
// Uses an increasing timeout to avoid calling forever at 100ms intervals
function ajaxHookProductWishlistWidget(elementId, productData, timeout)
{
  if (elementId == undefined) {
    return;
  }

  if(typeof timeout === 'undefined') { timeout = 100; }

  var element = document.getElementById(elementId);
  if (element) {
    React.render(
        React.createElement(
            AddToMoodboard, {
              moodboard:  window.app.user_moodboards.default(),
              product_id: productData.product_id,
              color_id:   productData.color_id
            }),
        element)
  } else {
    // Doubling the timeout on failure gives safe fall off in case the elements never appear.
    var newItemOut = timeout * 2;
    window.setTimeout(function () {
      ajaxHookProductWishlistWidget(elementId, productData, newItemOut)
    }, newItemOut);
  }
};
