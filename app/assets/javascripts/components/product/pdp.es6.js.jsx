// actions
function selectSize(size) {
  return {type: 'SELECT_SIZE', size};
}

// reducers
function customizeRedure(selectedSize = '', action) {
  switch (action.type) {
    case 'SELECT_SIZE':
      return Object.assign({}, action.size);
    default:
      return state;
  }
}

const customizeRed = customizeRedure();

const rootReducer = Redux.combineReducers({
  customizeRed
});

// store
function configureStore(initialState) {
  return Redux.createStore(
    rootReducer,
    initialState
  );
}

class PdpGallery extends React.Component {

  render() {
    return (
      <div className="panel-media">
        <div className="panel-media-inner-wrap">
          <div className="media-wrap">
            <img src="/assets/_temp/product-burgundy-crop.jpg" />
          </div>
          <div className="media-wrap">
            <img src="/assets/_temp/product-burgundy-crop.jpg" />
          </div>
          <div className="media-wrap">
            <img src="/assets/_temp/product-burgundy-crop.jpg" />
          </div>
        </div>
      </div>
    );
  }

}

class PdpSidePanelRight extends React.Component {
  constructor(props, context) {
    super(props, context);

    this.state = {
      customize: {
        size: ['US 0', 'US 2', 'US 4', 'US 6'],
        length: ['patite', 'standard', 'tall'],
        color: ['red', 'black'],
        custom: ['Change Skirt To Knee Length', 'Change Skirt To Full Length']
      }
    };

    this.openMenu = this.openMenu.bind(this);
    this.closeMenu = this.closeMenu.bind(this);
  }

  openMenu() {
    this.setState({active: true});
  }

  closeMenu() {
    this.setState({active: false});
  }

  render() {
    return (
      <div className="panel-side-container">

        <div>

          <div className="c-card-customize">
            <h2 className="h4 c-card-customize__header">Specify your size</h2>
            <PdpSidePanelSize />
            <PdpSidePanelLength />
          </div>

          <div className="c-card-customize">
            <h2 className="h4 c-card-customize__header">Design your dress</h2>
            <PdpSidePanelColor />
            <PdpSidePanelCustom />
          </div>

        </div>

        <div className="btn-wrap">
          <div className="price js-product-price">$0000</div>
          <a href="javascript:;" className="btn btn-black btn-lrg js-buy-button">ADD TO BAG</a>
          <div className="est-delivery">Estimated delivery 3-4 weeks</div>
        </div>

      </div>
    );
  }
}

class PdpSidePanelSize extends PdpSidePanelRight {
  constructor(props, context) {
    super(props, context);

    this.state = {
      active: false,
      selected: false,
      size: 'US6'
    };
  }

  onSelect() {
    this.props.dispatch(selectSize(this.state.size));
  }

  render() {
    const menuState = this.state.active ? 'side-menu is-active' : 'side-menu';
    console.log(this.state);
    const options = this.state.customize.size.map(function(size) {
      return (
        <div className="option-wrap">
          {size}
        </div>
      );
    });

    return (
      <div>
        <a href="javascript:;"
          className="c-card-customize__content is-selected"
          onClick={this.openMenu}>
          <div className="c-card-customize__content__left">Dresses Size</div>
          <div className="c-card-customize__content__right"></div>
        </a>

        <div className={menuState}>
          <div className="text-right">
            <a href="javascript:;"
              className="btn-close lg"
              onClick={this.closeMenu}>
                <span className="hide-visually">Close Menu</span>
            </a>
          </div>
          <h2 className="h4 c-card-customize__header">Choose your size</h2>
          {options}
        </div>
      </div>
    );
  }
}

class PdpSidePanelLength extends PdpSidePanelRight {
  constructor(props, context) {
    super(props, context);
  }

  render() {
    return (
      <a href="javascript:;" className="c-card-customize__content is-selected">
        <div className="c-card-customize__content__left">Skirt Length</div>
        <div className="c-card-customize__content__right"></div>
      </a>
    );
  }
}

class PdpSidePanelColor extends PdpSidePanelRight {
  constructor(props, context) {
    super(props, context);
  }

  render() {
    return (
      <a href="javascript:;" className="c-card-customize__content is-selected">
        <div className="c-card-customize__content__left">Color</div>
        <div className="c-card-customize__content__right"></div>
      </a>
    );
  }
}

class PdpSidePanelCustom extends PdpSidePanelRight {
  constructor(props, context) {
    super(props, context);
  }

  render() {
    return (
      <a href="javascript:;" className="c-card-customize__content is-selected">
        <div className="c-card-customize__content__left">Customize</div>
        <div className="c-card-customize__content__right"></div>
      </a>
    );
  }
}

const store = configureStore(window.PdpData);

function mapStateToProps(state) {
  return {
    customizeRed: state.size
  };
}

<ReactRedux.Provider store={store}>
  ReactDOM.render(
    ReactRedux.connect(mapStateToProps)(<PdpSidePanelRight />),
      document.getElementById('PdpSidePanelRight')
  );
</ReactRedux.Provider>
