var CustomizationsMenu = React.createClass({

  getInitialState: function() {
    return {
      options: {
        silhouette: [1,2,3,4,5],
        fabric: [1,2],
        colour: [1,2,3,4,5],
        length: [1,2,3,4,5],
        style: [1,2,3,4,5],
        fit: [1,2,3,4,5],
        size: [1,2,3,4,5,6,7,8,9,10,11,12,13,15,16],
        people: ['Foo', 'Bar', 'Baz', 'John', 'Doe'],
        heights: [1,2,3,4,5]

      },
      selectedOptions: {
        silhouette: null,
        fabric: null,
        colour: null,
        length: null,
        style: null,
        fit: null,
        size: null,
        height: null
      }
    };
  },

  show: function(ref) {
    var el = $(this.refs[ref].refs.container);
    el.on('transitionend', function(e){

      $(this).off('transitionend');
    });
    el.addClass('animate');

  },

  close: function(ref){
    var el = $(this.refs[ref].refs.container);
    // el.on('transitionend', function(e){
    //   debugger;
    //   $(this).off('transitionend');
    // });
    el.removeClass('animate');
  },

  selectCallback: function(customization, value){
    var _state = this.state;
    _state.selectedOptions[customization] = value;
    this.setState(_state);
  },

  startOver: function () {
    var _state = this.state;
    _state.selectedOptions = {
      silhouette: null,
      fabric: null,
      colour: null,
      length: null,
      style: null,
      fit: null,
      size: null,
      height: null
    };
    this.setState(_state);
  },

  renderRow: function (customizationItem, index) {
      var selectedOptions = this.state.selectedOptions,
          className = "icon icon-" + customizationItem,
          selectedValue = selectedOptions[customizationItem];
      if(selectedOptions[customizationItem]){
        className += ' selected'
      }

      if(customizationItem == 'fabric-colour' && selectedOptions.fabric && selectedOptions.colour){
        className += ' selected';
        selectedValue = selectedOptions.fabric + ' | ' + selectedOptions.colour
      }

      if(customizationItem == 'size' && selectedOptions.size && selectedOptions.height){
        className += ' selected';
        selectedValue = selectedOptions.height + ' | ' + selectedOptions.size
      }

      return (
        <li key={ index } className="row customization-type" onClick={ this.show.bind(this, customizationItem) }>
          <div className="col-sm-6 customization-column">
            <a href="#" className="">
              <i className={className}></i><span>{ customizationItem.split('-').join(' + ') }</span>
            </a>
          </div>
          <div className="col-sm-6 customization-column">
            <span>{ selectedValue }</span>
          </div>
        </li>
      );
  },

  render: function() {
    var customizationItems = ['silhouette', 'fabric-colour', 'length', 'style', 'fit', 'size']
    return(
      <div>
        <div className="title row">
          <div className="col-sm-6 text-left">
            <h1><em>Customize</em> it how you want.</h1>
          </div>
          <div className="col-sm-6 start-over">
            <button className="btn-transparent btn-italic" onClick={this.startOver}>Start Over</button>
          </div>
        </div>
        <div className="customizations">
          <div className="menu">
            <ul>
              { customizationItems.map(this.renderRow) }
            </ul>
          </div>
          <div className="floating-menu">

          </div>
          <div>
            <CustomizationSelector
              type="silhouette"
              selectCallback={this.selectCallback}
              closeCallback={this.close}
              options={this.state.options.silhouette}
              ref="silhouette"
              keyword="Choose"
              title="your perfect shape"
              description="Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."/>
            <FabricAndColourSelector
              colours={this.state.options.colour}
              fabrics={this.state.options.fabric}
              closeCallback={this.close}
              selectCallback={this.selectCallback}
              ref="fabric-colour"/>
            <CustomizationSelector
              type="length"
              selectCallback={this.selectCallback} options={this.state.options.length}
              closeCallback={this.close}
              ref="length"
              keyword="Choose"
              title="your length."
              description="Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."/>
            <CustomizationSelector
              type="style"
              selectCallback={this.selectCallback} options={this.state.options.style}
              closeCallback={this.close}
              ref="style"
              keyword="Add"
              title="on extra trimmings."
              description="Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."/>
            <CustomizationSelector
              type="fit"
              selectCallback={this.selectCallback} options={this.state.options.fit}
              closeCallback={this.close}
              ref="fit"
              keyword="Finesse"
              title="the way it fits."
              description="Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."/>
            <SizeSelector
              sizes={this.state.options.size}
              people={this.state.options.people}
              heights={this.state.options.heights}
              closeCallback={this.close}
              selectCallback={this.selectCallback}
              ref="size"/>
          </div>
        </div>

      </div>
    );
  }
})
