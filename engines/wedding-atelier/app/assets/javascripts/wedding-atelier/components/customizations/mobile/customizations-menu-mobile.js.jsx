var CustomizationsMenuMobile = React.createClass({
  propTypes: {
    changeCurrentCustomizationCallback: React.PropTypes.func,
    currentCustomization: React.PropTypes.string,
    customizations: React.PropTypes.object,
    selectCallback: React.PropTypes.func,
    selectedOptions: React.PropTypes.object,
    siteVersion: React.PropTypes.string,
    startOverCallback: React.PropTypes.func,
    goToSlide: React.PropTypes.func
  },

  show: function (currentCustomization) {
    this.props.changeCurrentCustomizationCallback(currentCustomization);
    this.props.goToSlide(2);
  },

  renderMenuList: function () {
    var customizationItems = ['silhouette', 'fabric-color', 'length', 'style', 'fit'];

    var menuItems = customizationItems.map(function (customizationItem, index) {
      var selectedOptions = this.props.selectedOptions,
          iconUrl = "/assets/wedding-atelier/icons/" + customizationItem + ".png",
          selectedValue = null;

      if(selectedOptions[customizationItem]) {
        selectedValue = selectedOptions[customizationItem].presentation;
      }

      if(customizationItem === 'fabric-color' && selectedOptions.fabric && selectedOptions.color) {
        selectedValue = selectedOptions.fabric.presentation + ' | ' + selectedOptions.color.presentation;
      }

      var iconClasses = 'icon icon-' + customizationItem;

      return (
        <li key={index} className="customizations-menu-mobile-list-item" onClick={this.show.bind(null, customizationItem)}>
          <div className="customizations-menu-mobile-list-wrapper">
            <div className="customizations-menu-mobile-list-box">
              <i className={iconClasses} />
              <p>{customizationItem.split('-').join(' and ')}</p>
            </div>
          </div>
          <p className="customizations-menu-mobile-list-label">{selectedValue}</p>
        </li>
      );
    }.bind(this));

    return (
      <ul className="customizations-menu-mobile-list">
        {menuItems}
      </ul>
    );
  },

  render: function() {

    return (
      <div className="customizations-menu-mobile">
        <div className="customizations-menu-mobile-body">
          <DressPreview selectedOptions={$.extend({},this.props.selectedOptions)}
            onZoomInCallback={this.props.goToSlide.bind(null, 0)}
            onZoomOutCallback={this.props.goToSlide.bind(null, 1)}/>
          <h1>
            <em>Customize</em> and make it yours.
          </h1>
          {this.renderMenuList()}
        </div>
        <div className="customizations-selector-mobile-actions-single">
          <button className="btn-black" onClick={this.props.goToSlide.bind(null, 0)}>done</button>
        </div>
      </div>
    );
  }
});
