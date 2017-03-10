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
    var input = this.refs.input,
        inputText = input.value,
        key = e.which || e.keyCode,
        charBeforeCursor = inputText[input.selectionStart - 1],
        deleteKey = key == 8,
        hideKeys = [32, 37,39].indexOf(key) > -1;

    if(deleteKey && this.state.captureTyping){
      var currentTyping = this.state.currentTyping.slice(0, -1),
          state = { currentTyping: currentTyping };

      if(!currentTyping.length) { state.items = this.props.initialItems; }
      this.setState(state);
    }

    if(deleteKey && charBeforeCursor == '@'){
      this.setState({
        showOptions: false,
        captureTyping: false,
        currentTyping: '',
        items: this.props.initialItems
       });
    }

    if(hideKeys && this.state.showOptions){
      this.setState({ showOptions: false, captureTyping: false });
    }
  },

  keyUpHandler: function(){
    debugger;
    if(this.state.currentTyping.length){
      var regexp = new RegExp('^' + this.state.currentTyping, 'i');
      var newItems = _.filter(this.state.items, function(item){
        return regexp.test(item);
      }.bind(this));

      if(newItems.length != this.state.items.length){
        this.setState({ items: newItems });
        if(!this.state.showOptions && newItems.length){
          this.setState({ showOptions: true });
        }
        if(newItems.length < 1){ this.setState({ showOptions: false }); }
      }
    }
  },

  keyPressHandler: function(e){
    debugger;
    var input = this.refs.input,
        inputText = input.value,
        charBeforeAt = inputText[input.selectionStart - 1],
        //check anything before @ is a whitespace
        showTags = ['', ' ', undefined].indexOf(charBeforeAt) > -1,
        enterPressed = (e.which == 13 || e.keyCode == 13);

    if(this.state.captureTyping){
      var currentTyping = this.state.currentTyping + e.key;
      this.setState({currentTyping: currentTyping});
    }

    if(e.key === '@' && showTags){
      this.setState({ showOptions: true, captureTyping: true });
    }

    if(this.state.showOptions && enterPressed){
      e.preventDefault();
      var selectedItem = this.state.items[this.state.selectedItemIndex],
          regExp = new RegExp('@' + this.state.currentTyping),
          completeItem = selectedItem.replace(this.state.currentTyping, '');

      this.refs.input.value += completeItem;
      this.resetState();
    }
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

  hideOptions: function(){
    this.resetState();
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
               onBlur={this.hideOptions}
               ref="input"
               placeholder="Start typing..." />
      </div>
    );
  }
});
