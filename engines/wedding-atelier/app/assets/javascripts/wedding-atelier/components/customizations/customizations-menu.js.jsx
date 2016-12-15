var CustomizationsMenu = React.createClass({

  propTypes: {
    selectedOptions: React.PropTypes.object,
    currentCustomization: React.PropTypes.string,
    changeCurrentCustomizationCallback: React.PropTypes.func,
    selectCallback: React.PropTypes.func,
    startOverCallback: React.PropTypes.func
  },

  show: function(currentCustomization) {
    var width = $(window).width();
    if(width > 768){
      $('.customization-selector').addClass('slideInLeft');
      var el = $('.js-customizations-container');
      el.one('transitionend', function(){
        $('.js-customizations-lateral-menu').addClass('animate');
      });
      el.addClass('animate');
    }else{
      $('.customization-selector').removeClass('slideInLeft');
    }

    this.props.changeCurrentCustomizationCallback(currentCustomization);
  },


  renderRow: function (customizationItem, index) {
      var selectedOptions = this.props.selectedOptions,
          className = "icon icon-" + customizationItem,
          selectedValue = null;


      if(selectedOptions[customizationItem]){
        selectedValue = selectedOptions[customizationItem].presentation;
      }

      if(selectedOptions[customizationItem]){
        className += ' selected';
      }

      if(customizationItem == 'fabric-colour' && selectedOptions.fabric && selectedOptions.colour){
        className += ' selected';
        selectedValue = selectedOptions.fabric.presentation + ' | ' + selectedOptions.colour.presentation;
      }

      if(customizationItem == 'size' && selectedOptions.size && selectedOptions.height){
        className += ' selected';
        selectedValue = selectedOptions.height.presentation + ' | ' + selectedOptions.size.presentation;
      }

      return (
        <li key={index} className="row customization-type" onClick={this.show.bind(null, customizationItem)}>
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

    return (
      <div className="customization-panel-container">
        <div className="customizations-lateral-menu js-customizations-lateral-menu hidden-xs">
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
