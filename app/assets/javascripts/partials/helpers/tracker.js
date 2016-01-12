window.track = {
  tracked: [],
  dataLayer: window.dataLayer || [],
  ga: window.ga || function () {},

  pageView: function (page_url) {
    this.ga('send', 'pageview', page_url);
  },

  remarketing_tag: function () {
    var conversion_type = 'remarketing_tag';
    var id              = 979620714;
    var image           = new Image(1, 1);

    if (_.contains(this.tracked, conversion_type)) {
      return false;
    }

    image.src = "//googleads.g.doubleclick.net/pagead/viewthroughconversion/" + id + "/?value=0&guid=ON&script=0";
    this.tracked.push(conversion_type);
  },

  conversion: function (conversion_type) {
    var image  = new Image(1, 1);
    var params = this.getConversionOptions(conversion_type);

    if (_.contains(this.tracked, conversion_type)) {
      return false;
    }

    if (_.isEmpty(params)) {
      return false;
    }

    image.src = "//www.googleadservices.com/pagead/conversion/" + params.id + "/?value=0&label=" + params.label + "&guid=ON&script=0";
    this.tracked.push(conversion_type);
  },

  getConversionOptions: function (code) {
    var all = {
      live_chat: {
        id: 979620714,
        label: 'FT_ICN6g1gYQ6qaP0wM'
      },
      sign_up: {
        id: 979620714,
        label: 'C9flCNah1gYQ6qaP0wM'
      },
      blog_view: {
        id: 979620714,
        label: '1ddKCM6i1gYQ6qaP0wM'
      },
      quiz_step1: {
        id: 979620714,
        label: 'SYn2CMaj1gYQ6qaP0wM'
      },
      quiz_step2: {
        id: 979620714,
        label: 'I_X_CL6k1gYQ6qaP0wM'
      },
      ask_friend: {
        id: 979620714,
        label: 'g1gICLal1gYQ6qaP0wM'
      },
      wishlist: {
        id: 979620714,
        label: 'QbWZCK6m1gYQ6qaP0wM'
      },
      customisation_sign_up: {
        id: 979620714,
        label: 'QE93CL7pjwcQ6qaP0wM'
      }
    };

    return all[code];
  },

  event: function (category, action, label, value) {
    var event_params = {
      hitType: 'event',
      eventCategory: category,
      eventAction: action
    };

    if (label != null) {
      event_params.eventLabel = label;
    }

    if (value != null) {
      event_params.eventValue = value;
    }

    this.ga('send', event_params);
  },

  addedToWishlist: function (label) {
    this.event('Wishlist', 'AddedToWishlist', label);
  },

  addedToCart: function (label, product) {
    this.dataLayer.push({
      "event": "addToCart",
      "product": {
        "currency": product.price.currency,
        "name": product.name,
        "price": product.price.amount,
        "sku": product.line_item_sku
      }
    });
    this.event('Products', 'AddedToCart', label);
    this.pageView('/cart/add');
  },

  quizOpened: function (label) {
    this.event('Style Quiz', 'Opened', label);
  },

  quizClickedNext: function (label) {
    this.event('Style Quiz', 'ClickedNext', label);
  },

  quizFinished: function (label) {
    this.event('Style Quiz', 'Finished', label);
  },

  search: function (label) {
    this.event('Searches', 'Searched', label);
  },

  openedSendToFriend: function (label) {
    this.event('SendToFriend', 'Opened', label);
  },

  sentSendToFriend: function (label) {
    this.event('SendToFriend', 'Sent', label);
  },

  twinAlertClick: function (label) {
    this.event('Products', 'TwinAlertClick', label);
  },

  twinAlertOpen: function (label) {
    this.event('Products', 'TwinAlertOpen', label);
  },

  twinAlertRegister: function (label) {
    this.event('Products', 'TwinAlertRegister', label);
  },

  inviteToPayOpened: function () {
    this.event('InviteToPay', 'Opened');
  },

  inviteToPaySent: function () {
    this.event('InviteToPay', 'Sent');
  },

  openedProductInfo: function (label) {
    this.event('Product', 'ProductInfoOpened', label);
  },

  selectedCustomisation: function (label) {
    this.event('Product', 'CustomisatioSelected', label);
  },

  followedStyleProductLink: function (label) {
    this.event('Product', 'StyleItLinkClicked', label);
  },

  clickedBookFreeStylingSession: function (label) {
    this.event('Product', 'BookFreeStylingSessionClicked', label);
  },

  AddPromocodeSuccess: function (label) {
    this.event('AddPromocode', 'Success', label);
  },

  AddPromocodeFailure: function (label) {
    this.event('AddPromocode', 'Failure', label);
  }
};
