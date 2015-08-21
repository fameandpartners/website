var OrderSummary = React.createClass({
  render: function(){
    var lineItems = this.props.cart.products.map(function (line_item) {
                    return (<LineItem line_item={line_item}/>)
                  });

    return (
        <div className="checkout-items">
          <CartSummaryHeading />
          <ul className="list-unstyled">
            {
              lineItems
            }
          </ul>
          <PromotionForm />
          <p>
            Sub Total<span class="pull-right">{this.props.cart.display_item_total}</span>
          </p>
          <p>
            Shipping<span class="pull-right">{this.props.cart.display_shipment_total}</span>
          </p>
          <p>
              Promotion ({this.props.cart.promocode})<span class="pull-right">{this.props.cart.display_promotion_total}</span>
          </p>
          <p>
            <strong>Total<span class="pull-right">{this.props.cart.display_total}</span></strong>
          </p>
        </div>
    );
  }
});

var OrderSummaryIcon = React.createClass({
  render: function() {
    return (<i className="icon icon-shopping-bag-check"></i>)
  }
});

var CartSummaryHeading = React.createClass({
  render: function () {
    return (<h3><OrderSummaryIcon /> Order summary</h3>);
  }
});



var LineItem = React.createClass({
  render: function() {


     var makingOptions = this.props.line_item.making_options.map(function (product_option) {
       return (<div className="small">{product_option.name}  {product_option.display_price }</div>)
     });


    var customisations = this.props.line_item.customizations.map(function (product_option) {
           return (<div className="small">{product_option.name}  {product_option.display_price }</div>)
         });

    return (
      <li className="cart-item" data-id={this.props.line_item.line_item_id}>
        <a className="remove-product fa fa-close pull-right link-grey" href="#"></a>
        <div className="cart-item-image-holder pull-left">
          <a href={ this.props.line_item.path }>
            <img src={this.props.line_item.image.large} width="80px" height="115px" alt={ this.props.line_item.name } />
          </a>
        </div>
        <div className="cart-item-info">
          <div className="heading">
            <span className="qty">{ this.props.line_item.quantity } &times; </span>
            <a href={ this.props.line_item.path }>{ this.props.line_item.name }</a>
          </div>


          <div className="clearfix">
            <div className="pull-left small">
              Size: <span>{ this.props.line_item.size.presentation },</span>
              Color: <span className="color">{ this.props.line_item.color.presentation }</span>
            </div>
            <div className="pull-right text-muted">{ this.props.line_item.price.display_price }</div>
          </div>


          <div className="cart-prices">
            {
              makingOptions
            }
            {
              customisations
            }
          </div>
        </div>

      </li>
    );
    // { this.props.line_item.price.currency } - { this.props.line_item.price.display_price }

  }
});

/*
<li class="cart-item" data-id="<%= product.line_item_id %>">
  <a class="remove-product fa fa-close pull-right link-grey" href="#0"></a>
  <div class="cart-item-image-holder pull-left">
    <a href="<%= product.path %>">
      <img alt="<%= product.name %>" class="cart-item-image" src="<%= product.image.large %>">
    </a>
  </div>
  <div class="cart-item-info">
    <div class="heading">
      <span class="qty"><%= product.quantity %> x </span>
      <a href="<%= product.path %>" class="cart-item-title"><%= product.name %></a>
    </div>
  </div>
  <div class="clearfi">
    <div class="pull-left small">
      Size: <span><%= product.size.presentation %>,</span>
      Color: <span class="color"><%= product.color.presentation %></span>
    </div>
    <div class="pull-right text-muted"><%= product.price.display_price %></div>
  </div>
  <div class="cart-prices">
    <% for making_option in product.making_options: %>
      <div class="small">
        <%= making_option.name %> + <%= making_option.display_price %>
        <!-- <a href="#" class="fa fa-close making-option-remove" data-id="<%= making_option.id %>"></a> -->
      </div>
    <% end %>
    <% for customization in product.customizations: %>
      <div class="small text-pink">
        <%= customization.name %> + <%= customization.display_price %>
        <!-- <a href="#" class="fa fa-close customization-remove" data-id="<%= customization.id %>"></a> -->
      </div>
    <% end %>
</li>



*/


var PromotionForm = React.createClass({
  ////<form class="promo-code" action="#">
  //  <label for="#promo-code" class="invisible">Promo Code</label>
  //  <div class="input-group">
  //    <input class="form-control form-control-md" id="promo-code" type="text" placeholder="Discount code"><span class="input-group-btn"><button class="btn btn-block btn-black btn-md promo-code-apply">Apply</button></span>
  //  </div>
  //</form>


  render: function(){
    return(
        <form className="promo-code" action="#">
          <label for="#promo-code" className="invisible">Promo Code</label>
          <div className="input-group">
            <input className="form-control form-control-md" id="promo-code" type="text" placeholder="Discount code" />
            <span className="input-group-btn">
              <button className="btn btn-block btn-black btn-md promo-code-apply">Apply</button>
            </span>
          </div>
        </form>
    );
  }
});


// var originalJST = React.createClass({
//  render: function(){
//    return(<div>
//    <h3><i class="icon icon-shopping-bag-check"></i>Order summary</h3>
//<ul class="cart-items">
//  <% for product in @cart.products: %>
//    <li class="cart-item" data-id="<%= product.line_item_id %>">
//      <a class="remove-product fa fa-close pull-right link-grey" href="#0"></a>
//      <div class="cart-item-image-holder pull-left">
//        <a href="<%= product.path %>">
//          <img alt="<%= product.name %>" class="cart-item-image" src="<%= product.image.large %>">
//        </a>
//      </div>
//      <div class="cart-item-info">
//        <div class="heading">
//          <span class="qty"><%= product.quantity %> &times; </span>
//          <a href="<%= product.path %>" class="cart-item-title"><%= product.name %></a>
//        </div>
//      </div>
//      <div class="clearfix">
//        <div class="pull-left small">
//          Size: <span><%= product.size.presentation %>,</span>
//          Color: <span class="color"><%= product.color.presentation %></span>
//        </div>
//        <div class="pull-right text-muted"><%= product.price.display_price %></div>
//      </div>
//      <div class="cart-prices">
//        <% for making_option in product.making_options: %>
//          <div class="small">
//            <%= making_option.name %> + <%= making_option.display_price %>
//            <!-- <a href="#" class="fa fa-close making-option-remove" data-id="<%= making_option.id %>"></a> -->
//          </div>
//        <% end %>
//        <% for customization in product.customizations: %>
//          <div class="small text-pink">
//            <%= customization.name %> + <%= customization.display_price %>
//            <!-- <a href="#" class="fa fa-close customization-remove" data-id="<%= customization.id %>"></a> -->
//          </div>
//        <% end %>
//    </li>
//  <% end %>
//</ul>
//
//<form class="promo-code" action="#">
//  <label for="#promo-code" class="invisible">Promo Code</label>
//  <div class="input-group">
//    <input class="form-control form-control-md" id="promo-code" type="text" placeholder="Discount code"><span class="input-group-btn"><button class="btn btn-block btn-black btn-md promo-code-apply">Apply</button></span>
//  </div>
//</form>
//
//<p>
//  Sub Total<span class="pull-right"><%= @cart.display_item_total %></span>
//</p>
//<p>
//  Shipping<span class="pull-right"><%= @cart.display_shipment_total %></span>
//</p>
//<p>
//  <% if @cart.promocode: %>
//    Promotion (<%= @cart.promocode %>)<span class="pull-right"><%= @cart.display_promotion_total %></span>
//  <% end %>
//</p>
//<p>
//  <strong>Total<span class="pull-right"><%= @cart.display_total %></span></strong>
//</p></div>);
//    });
