var CustomizationsMenu = React.createClass({

  propTypes: {
    selectedOptions: React.PropTypes.object,
    currentCustomization: React.PropTypes.string,
    changeCurrentCustomizationCallback: React.PropTypes.func,
    selectCallback: React.PropTypes.func,
    startOverCallback: React.PropTypes.func
  },

  show: function(currentCustomization) {
    var el = $('.js-customizations-container');
    el.one('transitionend', function(){
      $('.js-customizations-lateral-menu').addClass('animate')
    });
    el.addClass('animate');
    this.props.changeCurrentCustomizationCallback(currentCustomization);
  },


  renderRow: function (customizationItem, index) {
      var selectedOptions = this.props.selectedOptions,
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
        <li key={ index } className="row customization-type" onClick={this.show.bind(null, customizationItem)}>
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
            <div className="menu-option" key={index} onClick={this.props.changeCurrentCustomizationCallback.bind(null, entry)}>
              <img src={img} />
              <p>{entry.split('-').join(' and ')}</p>
            </div>
          )
        }.bind(this));

    var customizationContainerProps = {
      selectedOptions: this.props.selectedOptions,
      currentCustomization: this.props.currentCustomization,
      changeCurrentCustomizationCallback: this.props.changeCurrentCustomizationCallback,
      selectCallback: this.props.selectCallback
    };

    return (
      <div className="customization-panel-container">
        <div className="customizations-lateral-menu js-customizations-lateral-menu">
          { menuEntries }
        </div>
        <div className="title row">
          <div className="col-sm-6 text-left">
            <h1><em>Customize</em> it how you want.</h1>
          </div>
          <div className="col-sm-6 start-over">
            <button className="btn-transparent btn-italic" onClick={this.props.startOverCallback}>Start Over</button>
          </div>
        </div>
        <div className="customizations">
          <div className="menu">
            <ul>
              {customizationItems.map(this.renderRow)}
            </ul>
          </div>
          <CustomizationsContainer
            {...customizationContainerProps}
            />
        </div>
      </div>
    );
  }
})
