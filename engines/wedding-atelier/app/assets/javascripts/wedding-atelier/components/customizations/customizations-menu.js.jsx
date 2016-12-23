var CustomizationsMenu = React.createClass({

  propTypes: {
    siteVersion: React.PropTypes.string,
    selectedOptions: React.PropTypes.object,
    currentCustomization: React.PropTypes.string,
    changeCurrentCustomizationCallback: React.PropTypes.func,
    selectCallback: React.PropTypes.func,
    startOverCallback: React.PropTypes.func,
    changeContainerStateCallback: React.PropTypes.func,
    showCallback: React.PropTypes.func,
    showContainers: React.PropTypes.object
  },

  parseSizePresentation: function(userOrSize, height) {
    if(userOrSize.name) {
      // Build a regexp to get the matching size number depeding on the site version: US|AU
      var regexp = new RegExp(this.props.siteVersion + '/?(\\d+)', 'i');
      return height + ' | ' + userOrSize.name.match(regexp)[1];
    } else {
      return userOrSize.first_name + "'s size profile";
    }
  },

  additionalCostFor: function(customizationItem){
    var selectedOptions = this.props.selectedOptions;

    if(customizationItem === 'size' || customizationItem === 'silhouette'){ return null; }
    if(customizationItem === 'fabric-colour' && selectedOptions.fabric && selectedOptions.colour){
      return parseInt(selectedOptions.fabric.price) + parseInt(selectedOptions.colour.price);
    }

    if(selectedOptions[customizationItem]){
      return parseInt(selectedOptions[customizationItem].price);
    }
  },

  renderRow: function (customizationItem, index) {
    // TODO: pending refactor after mobile customizations merge
    var selectedOptions = this.props.selectedOptions,
        className = "icon icon-" + customizationItem,
        additionalCost = this.additionalCostFor(customizationItem),
        selectedValue = null;

    if(selectedOptions[customizationItem]) {
      selectedValue = selectedOptions[customizationItem].presentation;
      className += ' selected';
    }

    if(customizationItem == 'fabric-colour' && selectedOptions.fabric && selectedOptions.colour) {
      className += ' selected';
      selectedValue = selectedOptions.fabric.presentation + ' | ' + selectedOptions.colour.presentation;
    }

    if(customizationItem == 'size' && selectedOptions.size && selectedOptions.height) {
      className += ' selected';
      selectedValue = this.parseSizePresentation(selectedOptions.size, selectedOptions.height);
    }

    if(selectedValue && additionalCost){
      selectedValue += ' + $' + additionalCost;
    }

    return (
      <li key={index} className="row customization-type" onClick={this.props.showCallback.bind(null, customizationItem)}>
        <div className="col-sm-6 customization-column customization-box">
          <a href="#" className="customization-label">
            <i className={className}></i>
            <span>{customizationItem.split('-').join(' + ')}</span>
          </a>
        </div>
        <div className="col-sm-6 customization-column customization-value">
          <span>{selectedValue}</span>
        </div>
      </li>
    );
  },

  render: function() {
    var customizationItems = ['silhouette', 'fabric-colour', 'length', 'style', 'fit', 'size'],
        menuEntries = customizationItems.map(function(entry, index) {
          var img = "/assets/wedding-atelier/icons/" + entry + ".png";
          return (
            <div className="menu-option" key={index} onClick={this.props.changeCurrentCustomizationCallback.bind(null, entry)}>
              <img src={img} />
              <p>{entry.split('-').join(' and ')}</p>
            </div>
          );
        }.bind(this));

    var customizationContainerProps = {
      selectedOptions: this.props.selectedOptions,
      currentCustomization: this.props.currentCustomization,
      changeCurrentCustomizationCallback: this.props.changeCurrentCustomizationCallback,
      selectCallback: this.props.selectCallback
    };

    var lateralMenuClasses = classNames({
      'customizations-lateral-menu': true,
      'js-customizations-lateral-menu': true,
      'hidden-xs': true,
      'animate': this.props.showContainers.showLateralMenu
    });

    return (
      <div ref="panelContainer" className="customization-panel-container" onTransitionEnd={this.props.changeContainerStateCallback.bind(null, false)}>
        <div ref="lateralMenu" className={lateralMenuClasses}>
          {menuEntries}
        </div>

        <div className="title row">
          <div className="col-sm-6 col-xs-12 title-text">
            <h1><em>Customize</em> it how you want.</h1>
          </div>
          <div className="col-sm-6 start-over hidden-xs">
            <button className="btn-transparent btn-italic" onClick={this.props.startOverCallback}>Start Over</button>
          </div>
        </div>

        <div className="customizations">
          <div className="menu">
            <ul>
              {customizationItems.map(this.renderRow)}
            </ul>
          </div>
        </div>
      </div>
    );
  }
});
