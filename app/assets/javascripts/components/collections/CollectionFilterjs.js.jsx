var FilterOption = React.createClass({

  render: function() {
    return (
      <div className='filter-option'>
        <label>
          <div className={"thumb thumb-"+this.props.select+" "+this.props.name} name={this.props.name} data-pricemin={this.props.priceMin} data-pricemax={this.props.priceMax} >
          </div>
          {this.props.label}
        </label>
      </div>
    )
  }
});

var FilterRadioOption = React.createClass({

  render: function() {
    return (
      <div className='filter-radio-option' data-all={this.props.all == 'true'} name={this.props.name} data-pricemin={this.props.priceMin} data-pricemax={this.props.priceMax} >
        <span className={'radio-icon ' + this.props.select}> </span>
        {this.props.label}
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
      return (<FilterOption name={shape} label={shape.replace("_"," ")} select='false' />)
    });

    colors = this.props.colors.map(function(color){
      return (<FilterOption name={color.table.presentation} label={color.table.presentation} select='false' />)
    });

    selectColors = this.props.selectColors.map(function(color){
      return (<SelectColor name={color.table.presentation} />)
    });

    styles = this.props.styles.map(function(style){
      return (<FilterOption name={style.table.name} label={style.table.name} select='false'/>)
    });

    currency = this.props.currency
    if (currency == 'usd') {
      priceList = [{min: 0,max :199}, {min:200, max:299}, {min: 300, max: 399}, {min: 400, max: null}]
    } else {
      priceList = [{min: 0,max :199}, {min:200, max:299}, {min: 300, max: 399}, {min: 400, max: null}]
    }

    prices = priceList.map(function(price){
      if (price.max != null) return (<FilterRadioOption name="price" label={"$"+price.min+" - $"+price.max} priceMin={price.min} priceMax={price.max} select='false'/>)
      else return (<FilterRadioOption name="price" label={"$"+price.min+"+"} priceMin={price.min} select=''/>)
    });

    return (
      <div>

        <div className='filter-rect'>
          <i className="fa fa-filter"></i>
          <span className='filter-text'>Filter</span>
          <div className='close visible-xs visible-sm'>Close</div>
          <span className='clear-all'><b>Clear all</b></span>

        </div>
        <br/>

        <div className='three-filters'>
          <b>PRICE</b>
          <div className='filter-area filter-area-prices'>
            <FilterRadioOption name='price' label='View all prices' select='selected' all='true' />
            {prices}
          </div>

          <b>STYLES</b>
          <div className='filter-area filter-area-styles short-height'>
            <FilterOption name='all' label='View all styles' select='true'/>
            {styles}
          </div>
          <div className='show-more-styles'>
            More
          </div>
          <br/>

          <b>COLORS</b>
          <div className='filter-area filter-area-colors'>
            <div className='color-checkboxes'>
              <FilterOption name='all' label='View all colors' select='true'/>
              {colors}
              <FilterOption name='Cheetah' label='Cheetah' select='false'/>
              <FilterOption name='Rosebud' label='Rosebud' select='false'/>
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
            <FilterOption name='all' label='View all shapes' select='true'/>
            {shapes}
          </div>

        </div>
      </div>
    );
  }
});
