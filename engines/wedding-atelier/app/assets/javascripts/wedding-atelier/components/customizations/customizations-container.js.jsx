var CustomizationsContainer = React.createClass({
  propTypes: {
    selectedOptions: React.PropTypes.object,
    currentCustomization: React.PropTypes.string,
    changeCurrentCustomizationCallback: React.PropTypes.func,
    selectCallback: React.PropTypes.func
  },

  componentDidUpdate: function(){
    $('.customization-selector').hide()
    $(ReactDOM.findDOMNode(this.refs[this.props.currentCustomization])).show()
  },

  getInitialState: function(){
    return  {
      silhouettes: [1,2,3,4,5],
      fabrics: [1,2],
      colours: [1,2,3,4,5],
      lengths: [1,2,3,4,5],
      styles: [1,2,3,4,5],
      fits: [1,2,3,4,5],
      sizes: [1,2,3,4,5,6,7,8,9,10,11,12,13,15,16],
      people: ['Foo', 'Bar', 'Baz', 'John', 'Doe'],
      heights: [1,2,3,4,5]
    };
  },

  close: function(ref){
    var el = $('.js-customizations-lateral-menu');
    if(!el.is(':visible')) {
      $('.js-customizations-container').removeClass('animate');
    } else {
      el.one('transitionend', function() {
        $('.js-customizations-container').removeClass('animate');
      }.bind(this));
      el.removeClass('animate');
    }
  },

  render: function(){
    var currentCustomization = this.props.currentCustomization,
        title = currentCustomization ? currentCustomization.split('-').join(' and ') : '';

    return (
      <div ref="customizationsContainer" className="js-customizations-container customizations-container">
        <div className="selector-header">
          <i className={"icon icon-" + currentCustomization}></i>
          <div className="selector-name text-left">{title}</div>
          <div className="selector-close" onClick={this.close}></div>
        </div>
        <div className="selector-body">
          <CustomizationSelector
            type="silhouette"
            selectCallback={this.props.selectCallback}
            options={this.state.silhouettes}
            ref="silhouette"
            keyword="Choose"
            title="your perfect shape"
            description="Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."/>
          <FabricAndColourSelector
            colours={this.state.colours}
            fabrics={this.state.fabrics}
            selectCallback={this.props.selectCallback}
            ref="fabric-colour"/>
          <CustomizationSelector
            type="length"
            selectCallback={this.props.selectCallback} options={this.state.lengths}
            ref="length"
            keyword="Choose"
            title="your length."
            description="Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."/>
          <CustomizationSelector
            type="style"
            selectCallback={this.props.selectCallback} options={this.state.styles}
            ref="style"
            keyword="Add"
            title="on extra trimmings."
            description="Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."/>
          <CustomizationSelector
            type="fit"
            selectCallback={this.props.selectCallback} options={this.state.fits}
            ref="fit"
            keyword="Finesse"
            title="the way it fits."
            description="Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."/>
          <SizeSelector
            sizes={this.state.sizes}
            people={this.state.people}
            heights={this.state.heights}
            selectCallback={this.props.selectCallback}
            ref="size"/>
        </div>
      </div>
    )
  }
})
