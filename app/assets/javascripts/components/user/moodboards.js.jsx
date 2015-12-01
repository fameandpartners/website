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

/**
 * Takes a moodboard, color_id, and product_id
 * Draws a list of boards, allows the user to add to the board,
 * and displays if the item in the selected colour is on the board.
 */
var AddProductToAnyMoodboard = React.createClass({
  getInitialState() {
    return {
      product_id: this.props.product_id,
      color_id:   this.props.color_id
    };
  },

  componentDidMount: function(){
    window.app.events.on('productSelectionOptionsChange', this.handleProductSelectionOptionsChange);
    window.app.user_moodboards.on('change', this.handleMoodboardUpdate);
  },

  // When the user changes the color, we need to know about it.
  // See app/assets/javascripts/partials/product_details.js.coffee
  handleProductSelectionOptionsChange: function(event, data){
    this.setState({ color_id: data.color_id });
  },

  handleMoodboardUpdate: function(_ev){
    this.forceUpdate();
  },

  addItem: function(item) {
    window.app.user_moodboards.addItem(item);
  },

  hasItem: function(item) {
    return window.app.user_moodboards.hasItem(item);
  },

  render: function(){
    var boards = this.props.moodboards.moodboards.map(function(moodboard) {
      var item = {
        moodboard_id: moodboard.id,
        product_id:   this.props.product_id,
        color_id:     this.state.color_id
      };

      // TODO - This call makes this a non-pure function.
      // The user moodboards store is global mutable state.
      var onBoard = this.hasItem(item);

      return(<PerMoodboardProduct key={moodboard.id}
                                  addHandler={this.addItem}
                                  moodboard={moodboard}
                                  item={item}
                                  exists={onBoard}/>);
    }.bind(this));

    return(<ul className='list-unstyled'>{boards}</ul>);
  }
});

var PerMoodboardProduct = React.createClass({
  handleClick: function() {
    this.props.addHandler(this.props.item);
  },

  render: function(){
    if (this.props.exists) {
      return(<li><span>On <a href={this.props.moodboard.show_path}>{this.props.moodboard.name}</a></span></li>);
    } else {
      return(<li>
        <AddToMoodboardTrigger moodboard_name={this.props.moodboard.name} addHandler={this.handleClick} />
      </li>);
    }
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
