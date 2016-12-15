var CustomizationExperience = React.createClass({
  propTypes: {
    dressesUrl: React.PropTypes.string
  },

  getInitialState: function() {
    return {
      currentCustomization: null,
      customizations: {
        silhouettes: [],
        fabrics: [1,2],
        colours: [1,2,3,4,5],
        lengths: [1,2,3,4,5],
        styles: [1,2,3,4,5],
        fits: [1,2,3,4,5],
        sizes: [1,2,3,4,5,6,7,8,9,10,11,12,13,15,16],
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

  componentDidMount: function(){
    $.get(this.props.dressesUrl, function(data){
      var _state = this.state;
      _state.customizations.silhouettes = data.event_dresses;
      this.setState(_state);
    }.bind(this))
  },

  changeCurrentCustomizationCallback: function(currentCustomization){
    var _state = this.state;
    _state.currentCustomization = currentCustomization;
    this.setState(_state);
  },

  selectCallback: function(customization, value){
    var _state = this.state;
    _state.selectedOptions[customization] = value;
    this.setState(_state);
    var width = $(window).width();
    if(width < 768){
      $('.js-slick-hook').slick('slickGoTo', 1);
    }
  },

  startOverCallback: function () {
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


  render: function(){

    var props = {
      selectedOptions: this.state.selectedOptions,
      currentCustomization: this.state.currentCustomization,
      customizations: this.state.customizations,
      changeCurrentCustomizationCallback: this.changeCurrentCustomizationCallback,
      selectCallback: this.selectCallback,
      startOverCallback: this.startOverCallback
    };

    return(
      <div className="customization-experience container-fluid">
        <MobileCustomizations {...props} />
        <DesktopCustomizations {...props} />
      </div>
    );
  }
})
