var CustomizationsMenu = React.createClass({

  getInitialState: function() {
    return {
      options: {
        silhouette: [1,2,3,4,5],
        fabric: [1,2],
        colour: [1,2,3,4,5],
        length: [1,2,3,4,5],
        style: [1,2,3,4,5],
        fit: [1,2,3,4,5],
        size: [1,2,3,4,5]
      },
      selectedOptions: {
        silhouette: null,
        fabric: null,
        colour: null,
        length: null,
        style: null,
        fit: null,
        size: null
      }
    };
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

      return (
        <li key={ index } className="row" onClick={ this.show.bind(this, customizationItem) }>
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

  show: function(ref) {
    $(this.refs[ref].refs.container).show();
  },

  selectCallback: function(customization, value){
    var _state = this.state;
    _state.selectedOptions[customization] = value;
    this.setState(_state);
  },

  render: function() {
    var customizationItems = ['silhouette', 'fabric-colour', 'length', 'style', 'fit', 'size']
    return(
      <div>
        <div className="menu">
          <ul>
            { customizationItems.map(this.renderRow) }
          </ul>
        </div>
        <div>
          <CustomizationSelector
            type="silhouette"
            selectCallback={this.selectCallback}
            options={this.state.options.silhouette}
            ref="silhouette"
            keyword="Choose"
            title="your perfect shape"
            description="a;lskda;oksdakspdoak" />
          <FabricAndColourSelector
            colours={this.state.options.colour}
            fabrics={this.state.options.fabric}
            selectCallback={this.selectCallback}
            ref="fabric-colour"
          />
          <CustomizationSelector type="length" selectCallback={this.selectCallback} options={this.state.options.length} ref="length"/>
          <CustomizationSelector type="style" selectCallback={this.selectCallback} options={this.state.options.style} ref="style"/>
          <CustomizationSelector type="fit" selectCallback={this.selectCallback} options={this.state.options.fit} ref="fit"/>
          <SizeSelector
            sizes={this.state.options.sizes}
            selectCallback={this.selectCallback}
            ref="size"/>
        </div>
      </div>
    );
  }
})
