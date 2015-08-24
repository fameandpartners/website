var FilterAllOption = React.createClass({
  getInitialState: function() {
    return {checked: true};
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

var FilterOption = React.createClass({

  getInitialState: function() {
    return {checked: false};
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
      return (<FilterOption name={shape} label={shape} />)
    });

    colors = this.props.colors.map(function(color){
      return (<FilterOption name={color.table.presentation} label={color.table.presentation} />)
    });

    styles = this.props.styles.map(function(style){
      return (<FilterOption name={style.table.name} label={style.table.name} />)
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
            <FilterAllOption name='' label='View all styles' />
            {styles}
          </div>
          <br/>

          <b>COLORS</b>
          <div className='filterArea filterAreaColors'>
            <FilterAllOption name='' label='View all colors' />
            {colors}
          </div>
          <br/>

          <b>BODYSHAPE</b>
          <div className='filterArea filterAreaShapes'>
            <FilterAllOption name='' label='View all shapes' />
            {shapes}
          </div>
        </div>
      </div>
    );
  }
});
