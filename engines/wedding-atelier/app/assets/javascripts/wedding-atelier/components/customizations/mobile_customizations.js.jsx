var MobileCustomizations = React.createClass({
  render: function() {

    return(
      <div className="customization-experience--mobile hidden-sm hidden-md hidden-lg">
        <h1>You are designing #{"the Wonderland"}</h1>
        <div className="dress-preview"></div>
        <div className="customization-panel hidden">
          <h1>
            <em>Customize</em> it how you want
          </h1>
          <ul>
            <li>
              <a href="#">
                <div className="customization-item-box table-cell-middle">
                  <img src="/assets/wedding-atelier/icons/silhouette.png" />
                  <p className="customization-label">silhouette</p>
                </div>
              </a>
              <p className="customization-value">Strapless Column</p>
            </li>
            <li>
              <a href="#">
                <div className="customization-item-box table-cell-middle">
                  <img src="/assets/wedding-atelier/icons/fabric-colour.png"/>
                  <p className="customization-label">Fabric + Colour</p>
                </div>
              </a>
              <p className="customization-value">Heavy Gerogette | Navy + $12</p>
            </li>
            <li>
              <a href="#">
                <div className="customization-item-box table-cell-middle">
                  <img src="/assets/wedding-atelier/icons/length.png"/>
                  <p className="customization-label">length</p>
                </div>
              </a>
              <p className="customization-value"></p>
            </li>
            <li>
              <a href="#">
                <span className="customization-item-box table-cell-middle">
                  <img src="/assets/wedding-atelier/icons/style.png"/>
                  <p className="customization-label">style</p>
                </span>
              </a>
            </li>
            <li>
              <a href="#">
                <span className="customization-item-box table-cell-middle">
                  <img src="/assets/wedding-atelier/icons/fit.png"/>
                  <p className="customization-label">fit</p>
                </span>
                <p className="customization-value"></p>
              </a>
            </li>
            <li>
              <a href="#">
                <span className="customization-item-box table-cell-middle">
                  <img src="/assets/wedding-atelier/icons/size.png" alt=""/>
                  <p className="customization-label">size</p>
                </span>
                <p className="customization-value"></p>
              </a>
            </li>
          </ul>
        </div>

        <button className="btn-transparent btn-block js-customize-dress">
          customize dress
        </button>
        <button className="btn-transparent btn-block">
          select size
        </button>

        <div className="results">
          <div className="view-customizations">
            <span className="left-result">
              <a href="#">View customizations</a>
            </span>
            <span className="right-result">$16</span>
          </div>
          <div className="sub-total">
            <span className="left-result">Sub-total</span>
            <span className="right-result">$320</span>
          </div>
        </div>

        <p className="estimated-delivery">
          Estimated delivery 7 days
        </p>
        <div className="actions">
          <button className="btn-gray">save to board</button>
          <button className="btn-black">add to cart</button>
        </div>
      </div>
    )
  }
})
