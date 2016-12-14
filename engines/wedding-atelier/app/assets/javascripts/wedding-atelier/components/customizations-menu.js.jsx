var CustomizationsMenu = React.createClass({

  getInitialState: function() {
    return {
      currentCustomization: null,
      selectedOptions: {
        silhouette: null,
        fabric: null,
        colour: null,
        length: null,
        style: null,
        fit: null,
        size: null,
        height: null
      }
    };
  },

  show: function(currentCustomization) {
    var el = $('.js-customizations-container');
    el.on('transitionend', function(e){

      $(this).off('transitionend');
    });
    el.addClass('animate');
    var _state = this.state;
    _state.currentCustomization = currentCustomization;
    this.setState(_state);
  },

  close: function(ref){
    var el = $(this.refs[ref].refs.container);
    // el.on('transitionend', function(e){
    //   debugger;
    //   $(this).off('transitionend');
    // });
    el.removeClass('animate');
  },

  selectCallback: function(customization, value){
    var _state = this.state;
    _state.selectedOptions[customization] = value;
    this.setState(_state);
  },

  startOver: function () {
    var _state = this.state;
    _state.selectedOptions = {
      silhouette: null,
      fabric: null,
      colour: null,
      length: null,
      style: null,
      fit: null,
      size: null,
      height: null
    };
    this.setState(_state);
  },

  renderRow: function (customizationItem, index) {
      var selectedOptions = this.state.selectedOptions,
          className = "icon icon-" + customizationItem,
          selectedValue = selectedOptions[customizationItem];
      if(selectedOptions[customizationItem]){
        className += ' selected'
      }

      if(customizationItem == 'fabric-colour' && selectedOptions.fabric && selectedOptions.colour){
        className += ' selected';
        selectedValue = selectedOptions.fabric + ' | ' + selectedOptions.colour
      }

      if(customizationItem == 'size' && selectedOptions.size && selectedOptions.height){
        className += ' selected';
        selectedValue = selectedOptions.height + ' | ' + selectedOptions.size
      }

      return (
        <li key={ index } className="row customization-type" onClick={ this.show.bind(this, customizationItem) }>
          <div className="col-sm-6 customization-column">
            <a href="#" className="">
              <i className={className}></i><span>{ customizationItem.split('-').join(' + ') }</span>
            </a>
          </div>
          <div className="col-sm-6 customization-column">
            <span>{ selectedValue }</span>
          </div>
        </li>
      );
  },

  render: function() {
    var customizationItems = ['silhouette', 'fabric-colour', 'length', 'style', 'fit', 'size']
    return(
      <div>
        <div className="title row">
          <div className="col-sm-6 text-left">
            <h1><em>Customize</em> it how you want.</h1>
          </div>
          <div className="col-sm-6 start-over">
            <button className="btn-transparent btn-italic" onClick={this.startOver}>Start Over</button>
          </div>
        </div>
        <div className="customizations">
          <div className="menu">
            <ul>
              { customizationItems.map(this.renderRow) }
            </ul>
          </div>
          <div className="floating-menu">

          </div>
          <CustomizationsContainer
            selectedOptions={this.state.selectedOptions}
            currentCustomization={this.state.currentCustomization}
            selectCallback={this.selectCallback}
            />
        </div>
      </div>
    );
  }
})
