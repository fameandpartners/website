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

  renderRow: function (customizationItem, index) {
    // TODO: pending refactor after mobile customizations merge
    var selectedOptions = this.props.selectedOptions,
        className = "icon icon-" + customizationItem,
        presentation = PresentationHelper.presentation(selectedOptions, customizationItem, this.props.siteVersion);

    if(selectedOptions[customizationItem]) {
      className += ' selected';
    }

    if(customizationItem == 'fabric-color' && selectedOptions.fabric && selectedOptions.color) {
      className += ' selected';
    }

    if(customizationItem == 'size' && selectedOptions.size && selectedOptions.height) {
      className += ' selected';
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
          <span>{presentation}</span>
        </div>
      </li>
    );
  },

  isOptionSet: function(entry){
    var options = this.props.selectedOptions
    if(entry == 'fabric-color'){
      return options['colour'] && options['size'] ? 'selected' : '';
    }else{
      return options[entry] ? 'selected' : '';
    }
  },

  render: function() {
    var customizationItems = ['silhouette', 'fabric-color', 'length', 'style', 'fit', 'size'],
        menuEntries = customizationItems.map(function(entry, index) {
          var selected = this.isOptionSet(entry),
              iconClasses = 'icon icon-' + entry + ' ' + selected,
              menuOptionClasses = classNames({
                'menu-option': true,
                current: this.props.currentCustomization == entry
              })

          return (
            <div className={menuOptionClasses} key={index} onClick={this.props.changeCurrentCustomizationCallback.bind(null, entry)}>
              <i className={iconClasses} />
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
            <h1><em>Customize</em> and make it yours.</h1>
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
