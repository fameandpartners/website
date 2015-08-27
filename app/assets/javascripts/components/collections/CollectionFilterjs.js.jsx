var FilterAllOption = React.createClass({

  render: function() {
    return (
      <div className='filterOption'>
        <label>
          <div className={"thumb thumbtrue "+this.props.name} name={this.props.name} >
          </div>
          {this.props.label}
        </label>
      </div>
    )
  }
});

var FilterOption = React.createClass({

  render: function() {
    return (
      <div className='filterOption'>
        <label>
          <div className={"thumb thumbfalse "+this.props.name} name={this.props.name}>
          </div>
          {this.props.label}
        </label>
      </div>
    )
  }
});


var SelectColor = React.createClass({

  render: function() {
    return (
      <option name={this.props.name} value={this.props.name}>
        {this.props.name}
      </option>
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

    selectColors = this.props.selectColors.map(function(color){
      return (<SelectColor name={color.table.presentation} />)
    });

    styles = this.props.styles.map(function(style){
      return (<FilterOption name={style.table.name} label={style.table.name} />)
    });

    return (
      <div>

        <div className='filterRect'>
          <span className='filterText'>Filter</span>
          <span className='clearAll'><b>Clear all</b></span>
        </div>
        <br/>

        <div>
          <b>STYLES</b>
          <div className='filterArea filterAreaStyles'>
            <FilterAllOption name='all' label='View all styles' />
            {styles}
          </div>
          <div className='showMoreStyles'>
            More
          </div>
          <br/>

          <b>COLORS</b>
          <div className='filterArea filterAreaColors'>
            <div className='colorCheckboxes'>
              <FilterAllOption name='all' label='View all colors' />
              {colors}
            </div>
            Other colours
            <div className='selectColor'>
              <select>
                <option name="none" value="none" selected>Please select one</option>
                {selectColors}
              </select>
            </div>
            <br/>
          </div>



          <b>BODYSHAPE</b>
          <div className='filterArea filterAreaShapes'>
            <FilterAllOption name='all' label='View all shapes' />
            {shapes}
          </div>
        </div>
      </div>
    );
  }
});
