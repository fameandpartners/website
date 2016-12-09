var CustomizationsMenu = React.createClass({

  getInitialState: function(){
    return {
      silhouette: null
    }
  },

  show: function(ref){
    $(this.refs[ref].refs.container).show();
  },

  selectCustomization: function(customization, value){
    var _state = this.state;
    _state[customization] = value;
    this.setState(_state);
  },

  render: function(){
    return(
      <div>
        <div className="menu">
          <ul>
            <li className="row" onClick={this.show.bind(this, 'silhouetteSelector')}>
              <div className="col-sm-6 customization-column"><a href="#" className="">
              <i className="icon icon-silhouettes"></i><span>silhouettes</span></a>
              </div>
              <div className="col-sm-6 customization-column">
                <span>{this.state.silhouette}</span>
              </div>
            </li>
            <li className="row">
              <div className="col-sm-6 customization-column"><a href="#" className="">
              <i className="icon icon-fabric-colour"></i><span>colour</span></a>
              </div>
              <div className="col-sm-6 customization-column">
                <span>Heavy Georgette | Navy + $12</span>
              </div>
            </li>
            <li className="row">
              <div className="col-sm-6 customization-column"><a href="#" className="">
              <i className="icon icon-length"></i><span>length</span></a>
              </div>
              <div className="col-sm-6 customization-column">
                <span></span>
              </div>
            </li>
            <li className="row">
              <div className="col-sm-6 customization-column"><a href="#" className="">
              <i className="icon icon-style"></i><span>style</span></a>
              </div>
              <div className="col-sm-6 customization-column">
              <span></span>
              </div>
            </li>
            <li className="row">
              <div className="col-sm-6 customization-column"><a href="#" className="">
              <i className="icon icon-fit"></i><span>fit</span></a>
              </div>
              <div className="col-sm-6 customization-column">
              <span></span>
              </div>
            </li>
            <li className="row">
              <div className="col-sm-6 customization-column"><a href="#" className="">
              <i className="icon icon-size"></i><span>size</span></a>
              </div>
              <div className="col-sm-6 customization-column">
              <span></span>
              </div>
            </li>
          </ul>
        </div>
        <div>
          <SilhouetteSelector ref="silhouetteSelector" selectCallback={this.selectCustomization} dresses={this.props.dresses} />
        </div>
      </div>
    )
  }
})
