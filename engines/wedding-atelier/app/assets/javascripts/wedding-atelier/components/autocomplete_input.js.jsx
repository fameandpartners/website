var AutocompleteInput = React.createClass({
  propTypes: {
    changeHandler: React.PropTypes.func,
    keypressHandler: React.PropTypes.func,
    initialItems: React.PropTypes.array
  },

  getInitialState: function(){
    return {
      items: this.props.initialItems,
      selectedItemIndex: 0,
      showOptions: false,
      captureTyping: false,
      currentTyping: ''
    };
  },

  keyDownHandler: function(e){
    var _newState = this.state,
        input = this.refs.input,
        inputText = input.value,
        key = e.which || e.keyCode,
        charBeforeCursor = inputText[input.selectionStart - 1],
        deleteKey = key == 8,
        hideKeys = [32, 37, 39].indexOf(key) > -1;

    if(deleteKey && this.state.captureTyping){
      var currentTyping = this.state.currentTyping.slice(0, -1);
      _newState.currentTyping = currentTyping;
      if(!currentTyping.length) { _newState.items = this.props.initialItems; }
    }

    if((deleteKey && charBeforeCursor == '@') || (hideKeys && this.state.showOptions)){
      _newState = $.extend({},this.getInitialState());
    }

    this.setState(_newState);
  },

  keyUpHandler: function(){
    if(this.state.currentTyping.length){
      var _newState = $.extend({}, this.state),
          regexp = new RegExp('^' + this.state.currentTyping, 'i');

      var newItems = _.filter(this.state.items, function(item){
        return regexp.test(item);
      }.bind(this));

      if(newItems.length){
        _newState.items = newItems;
        _newState.showOptions = true;
      } else {
        _newState.items = this.props.initialItems;
        _newState.showOptions = false;
      }

      this.setState(_newState);
    }
  },

  keyPressHandler: function(e){
    var _newState = $.extend({}, this.state),
        input = this.refs.input,
        inputText = input.value,
        keyCode = e.which || e.keyCode,
        charBeforeAt = inputText[input.selectionStart - 1],
        //check anything before @ is a whitespace
        showTags = ['', ' ', undefined].indexOf(charBeforeAt) > -1,
        enterPressed = keyCode == 13;

    if(this.state.captureTyping){
      _newState.currentTyping = this.state.currentTyping + e.key
    }

    if(keyCode === 64 && showTags){
      _newState.showOptions = true;
      _newState.captureTyping = true;
    }

    if(this.state.showOptions && enterPressed){
      e.preventDefault();
      var selectedItem = this.state.items[this.state.selectedItemIndex],
          regExp = new RegExp('@' + this.state.currentTyping),
          completeItem = selectedItem.replace(this.state.currentTyping, '') + ': ';

      this.refs.input.value += completeItem;
      _newState = $.extend({},this.getInitialState());
    }
    this.setState(_newState);
  },

  resetState: function(){
    this.setState({
      showOptions: false,
      currentTyping: '',
      captureTyping: false,
      items: this.props.initialItems
    });
  },

  changeHandler: function(){
    this.props.changeHandler();
    if(!this.refs.input.value.length){
      this.setState({ showOptions: false });
    }
  },

  renderItems: function(){
    var that = this;
    return this.state.items.map(function(option, i){
      var className = classNames({
        "autocomplete-item": true,
        selected: i == that.state.selectedItemIndex
      });

      return (<p key={i} className={className}>@{option}</p>);
    });
  },

  renderOptions: function(){
    if(this.state.showOptions){
      return (
        <div className="autocomplete-list">
          <p className="title">get styling help</p>
          <div className="autocomplete-items">
            {this.renderItems()}
          </div>
        </div>
      );
    }
  },

  render: function(){
    return(
      <div className="autocomplete-input">
        {this.renderOptions()}
        <input type="text"
               autoComplete="off"
               onChange={this.changeHandler}
               onKeyPress={this.keyPressHandler}
               onKeyDown={this.keyDownHandler}
               onKeyUp={this.keyUpHandler}
               onBlur={this.resetState}
               ref="input"
               placeholder="Start typing..." />
      </div>
    );
  }
});
