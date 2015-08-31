var FilterAllOption = React.createClass({

  render: function() {
    return (
      <div className='filter-option'>
        <label>
          <div className={"thumb thumb-true "+this.props.name} name={this.props.name} >
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
      <div className='filter-option'>
        <label>
          <div className={"thumb thumb-false "+this.props.name} name={this.props.name}>
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
      return (<FilterOption name={shape} label={shape.replace("_"," ")} />)
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

        <div className='filter-rect'>
          <div className='filter-icon'></div>
          <span className='filter-text'>Filter</span>
          <div className='close visible-xs visible-sm'>Close</div>
          <span className='clear-all'><b>Clear all</b></span>

        </div>
        <br/>

        <div className='three-filters'>
          <b>STYLES</b>
          <div className='filter-area filter-area-styles short-height'>
            <FilterAllOption name='all' label='View all styles' />
            {styles}
          </div>
          <div className='show-more-styles'>
            More
          </div>
          <br/>

          <b>COLORS</b>
          <div className='filter-area filter-area-colors'>
            <div className='color-checkboxes'>
              <FilterAllOption name='all' label='View all colors' />
              {colors}
            </div>
            Other colours
            <div className='select-color'>
              <select>
                <option name="none" value="none" selected>Please select one</option>
                {selectColors}
              </select>
            </div>
            <br/>
          </div>



          <b>BODYSHAPE</b>
          <div className='filter-area filter-area-shapes'>
            <FilterAllOption name='all' label='View all shapes' />
            {shapes}
          </div>
        </div>
      </div>
    );
  }
});
