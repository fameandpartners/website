var FilterOption = React.createClass({

  componentDidMount: function(){
    $(this.getDOMNode()).find('.selected').prop('checked', 'checked');
  },

  render: function() {
    return (
      <div className='custom-form-element filter-option selector-styles' name={this.props.label}>
        <label className={'swatch-color-' + this.props.name}>
          <input className={this.props.select == 'selected' ? 'selected' : ''} type='checkbox' name={this.props.label} />
          <span className='icon'></span>
          <span>{this.props.label}</span>
        </label>
      </div>
    )
  }
});

var FilterRadioOption = React.createClass({

  componentDidMount: function(){
    $(this.getDOMNode()).find('.selected').prop('checked', 'checked');
  },

  render: function() {
    return (
      <div className='custom-form-element filter-radio-option selector-price' 
        name={this.props.name} >
        <label>
          <input className={this.props.select == 'selected' ? 'selected' : ''} 
            type='radio' 
            name={this.props.name} 
            data-all={this.props.all == 'true'} 
            data-pricemin={this.props.priceMin} 
            data-pricemax={this.props.priceMax} />
          <span className='icon'></span>
          <span>{this.props.label}</span>
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
      return (<FilterOption name={shape} label={shape.replace("_"," ")} select='false' />)
    });

    colors = this.props.colors.map(function(color){
      return (<FilterOption name={color.table.name} label={color.table.presentation} select='false' />)
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
      <div className='panel-group search-filters' id='filter-accordion' role='tablist' aria-multiselectable='true'>

        <div className='panel panel-default'>
          <div className='panel-heading title-wrap'>
            <span>
              <span className='icon icon-filter'></span>
              <span> Filters</span>
            </span>
            <a href='javascript:;' className='js-clear-all-filters'>Clear All</a>
          </div>
        </div>

        <div className='panel panel-default'>
          <div className='panel-heading' role='tab' id='heading-collapse-price'>
            <a className='panel-title collapsed' role='button' data-toggle='collapse' data-parent='#filter-accordion' href='#collapse-price' aria-expanded='true' aria-controls='collapse-price'>
              PRICE
            </a>
          </div>
          <div id='collapse-price' className='panel-collapse collapse' role='tabpanel' aria-labelledby='heading-collapse-price'>
            <div className='panel-body'>
              <FilterRadioOption name='price' label='View all prices' select='selected' all='true' />
              {prices}
            </div>
          </div>
        </div>

        <div className='panel panel-default'>
          <div className='panel-heading' role='tab' id='heading-collapse-style'>
            <a className='panel-title collapsed' role='button' data-toggle='collapse' data-parent='#filter-accordion' href='#collapse-style' aria-expanded='true' aria-controls='collapse-style'>
              STYLES
            </a>
          </div>
          <div id='collapse-style' className='panel-collapse collapse' role='tabpanel' aria-labelledby='heading-collapse-style'>
            <div className='panel-body'>
              <FilterOption name='all' label='View all styles' select='true'/>
              {styles}
            </div>
          </div>
        </div>

        <div className='panel panel-default'>
          <div className='panel-heading' role='tab' id='heading-collapse-colors'>
            <a className='panel-title collapsed' role='button' data-toggle='collapse' data-parent='#filter-accordion' href='#collapse-colors' aria-expanded='true' aria-controls='collapse-colors'>
              COLORS
            </a>
          </div>
          <div id='collapse-colors' className='panel-collapse collapse' role='tabpanel' aria-labelledby='heading-collapse-colors'>
            <div className='panel-body'>
              <div className='color-checkboxes'>
                <FilterOption name='all' label='View all colors' select='true'/>
                {colors}
                <FilterOption name='Cheetah' label='Cheetah' select='false'/>
                <FilterOption name='Rosebud' label='Rosebud' select='false'/>
              </div>
              <div className='form-group select-color'>
                <label htmlFor='other-colors'>Other colours</label>
                <select id='other-colors' className='form-control'>
                  <option name="none" value="none" selected>Please select one</option>
                  {selectColors}
                </select>
              </div>
            </div>
          </div>
        </div>

        <div className='panel panel-default'>
          <div className='panel-heading' role='tab' id='heading-collapse-bodyshape'>
            <a className='panel-title collapsed' role='button' data-toggle='collapse' data-parent='#accordion' href='#collapse-bodyshape' aria-expanded='true' aria-controls='collapse-bodyshape'>
              BODYSHAPE
            </a>
          </div>
          <div id='collapse-bodyshape' className='panel-collapse collapse' role='tabpanel' aria-labelledby='heading-collapse-bodyshape'>
            <div className='panel-body'>
              <FilterOption name='all' label='View all shapes' select='true'/>
              {shapes}
            </div>
          </div>
        </div>

      </div>
    );
  }
});
