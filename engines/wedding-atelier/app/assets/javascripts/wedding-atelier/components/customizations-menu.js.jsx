var CustomizationsMenu = React.createClass({

  getInitialState: function() {
    return {
      silhouette: null
    }
  },

  renderRow: function (customizationItem) {
      return (
        <li className="row" onClick={ this.show.bind(this, customizationItem + 'Selector') }>
          <div className="col-sm-6 customization-column">
            <a href="#" className="">
              <i className={"icon icon-" + customizationItem}></i><span>{ customizationItem.split('-').join(' + ') }</span>
            </a>
          </div>
          <div className="col-sm-6 customization-column">
            <span>{ this.state[customizationItem] }</span>
          </div>
        </li>
      );
  },

  show: function(ref) {
    $(this.refs[ref].refs.container).show();
  },

  selectCustomization: function(customization, value){
    var _state = this.state;
    _state[customization] = value;
    this.setState(_state);
  },

  render: function() {
    var customizationItems = ['silhouette', 'fabric-colour', 'length', 'style', 'fit', 'size'];

    return(
      <div>
        <div className="menu">
          <ul>
            { customizationItems.map(this.renderRow) }
          </ul>
        </div>
        <div>
          <SilhouetteSelector ref="silhouetteSelector" selectCallback={this.selectCustomization} dresses={this.props.dresses} />
        </div>
      </div>
    )
  }
})
