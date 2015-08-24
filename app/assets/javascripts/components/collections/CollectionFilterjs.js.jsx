var ReactCheckbox = React.createClass({

  getInitialState: function() {
    return {checked: this.props.name == ''};
  },

  check: function(){
    this.setState({checked: !this.state.checked});
  },

  render: function() {
    return (
      <div className='filterOption'>
        <label>
          <input type="checkbox" checked={this.state.checked} name={this.props.name} onChange={this.check}>
          </input>
          {this.props.label}
        </label>
      </div>
    )
  }
});



var CollectionFilter = React.createClass({

  render: function() {
    shapes = this.props.shapes.map(function(shape){
      return (<ReactCheckbox name={shape} label={shape} />)
    });

    colors = this.props.colors.map(function(color){
      return (<ReactCheckbox name={color.table.presentation} label={color.table.presentation} />)
    });

    styles = this.props.styles.map(function(style){
      return (<ReactCheckbox name={style.table.name} label={style.table.name} />)
    });

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
          <div className='filterArea filterAreaStyles'>
            <ReactCheckbox name='' label='View all styles' />
            {styles}
          </div>
          <br/>

          <b>COLORS</b>
          <div className='filterArea filterAreaColors'>
            <ReactCheckbox name='' label='View all colors' />
            {colors}
          </div>
          <br/>

          <b>BODYSHAPE</b>
          <div className='filterArea filterAreaShapes'>
            <ReactCheckbox name='' label='View all shapes' />
            {shapes}
          </div>
        </div>
      </div>
    );
  }
});
