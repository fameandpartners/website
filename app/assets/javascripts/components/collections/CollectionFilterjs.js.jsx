var ReactCheckbox = React.createClass({

  getInitialState: function(){
    checked: this.props.name = ''
  }

  check: function(){
    this.setState({checked: !this.state.checked})
  }

  render: function(){
    return(
      <input type="checkbox" checked={this.state.checked} onChange={this.check() name={this.props.name} }>
      </input>
    )
  }
});



var CollectionFilter = React.createClass({

  render: function() {
    shapes = [];
    for (var i=0; i < this.props.shapes.length; i++){
      shapes.push(<div className="filterOption"> <label><input type="checkbox"></input>{this.props.shapes[i]}</label> </div>)
    }

    colors = [];
    for (var i=0; i < this.props.colors.length; i++){
      colors.push(<div className="filterOption">  <label><input type="checkbox"></input>{this.props.colors[i].table.presentation}</label> </div>)
    }

    styles = [];
    for (var i=0; i < this.props.styles.length; i++){
      styles.push(<div className="filterOption">  <label><input type="checkbox"></input>{this.props.styles[i].table.name}</label> </div>)
    }
    return (
      <div>
        <div>
          Home / <b>Dresses</b>
        </div>

        <div className='filterRect'>
          <span className='filterText'>Filter</span>
          <span className='clearAll'><b>Clear all</b></span>
        </div>
        <br/>

        <div>
          <b>STYLES</b>
          <div className='filterArea'>
            <ReactCheckbox value='View all styles' />
          </div>
          <br/>

          <b>COLORS</b>
          <div className='filterArea'>
            {colors}
          </div>
          <br/>

          <b>BODYSHAPE</b>
          <div className='filterArea'>
            {shapes}
          </div>
        </div>
      </div>
    );
  }
});
