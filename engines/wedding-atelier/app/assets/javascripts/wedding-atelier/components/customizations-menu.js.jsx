var CustomizationsMenu = React.createClass({

  getInitialState: function() {
    return {
      options: {
        silhouette: [1,2,3,4,5],
        fabric: [1,2,3,4,5],
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
      return (
        <li key={ index } className="row" onClick={ this.show.bind(this, customizationItem) }>
          <div className="col-sm-6 customization-column">
            <a href="#" className="">
              <i className={"icon icon-" + customizationItem}></i><span>{ customizationItem.split('-').join(' + ') }</span>
            </a>
          </div>
          <div className="col-sm-6 customization-column">
            <span>{ this.state.selectedOptions[customizationItem] }</span>
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
          <FabricAndColorSelector type="silhouette"/>
          <CustomizationSelector type="length" selectCallback={this.selectCallback} options={this.state.options.length} ref="length"/>
          <CustomizationSelector type="style" selectCallback={this.selectCallback} options={this.state.options.style} ref="style"/>
          <CustomizationSelector type="fit" selectCallback={this.selectCallback} options={this.state.options.fit} ref="fit"/>
          <SizeSelector/>
        </div>
      </div>
    );
  }
})
