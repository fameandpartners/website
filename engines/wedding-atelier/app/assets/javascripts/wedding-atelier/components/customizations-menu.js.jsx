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
    el.one('transitionend', function(){
      $('.js-customizations-lateral-menu').addClass('animate')
    });
    el.addClass('animate');
    this.changeCurrentCustomization(currentCustomization);
  },

  changeCurrentCustomization: function(currentCustomization){
    var _state = this.state;
    _state.currentCustomization = currentCustomization;
    this.setState(_state);
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
        className += ' selected';
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
    var customizationItems = ['silhouette', 'fabric-colour', 'length', 'style', 'fit', 'size'],
        menuEntries = customizationItems.map(function(entry, index) {
          var img = "/assets/wedding-atelier/icons/" + entry + ".png";
          return (
            <div className="menu-option" key={index} onClick={this.changeCurrentCustomization.bind(this, entry)}>
              <img src={img} />
              <p>{entry.split('-').join(' and ')}</p>
            </div>
          )
        }.bind(this));
    return(
      <div>
        <div className="customizations-lateral-menu js-customizations-lateral-menu">
          { menuEntries }
        </div>
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
              {customizationItems.map(this.renderRow)}
            </ul>
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
