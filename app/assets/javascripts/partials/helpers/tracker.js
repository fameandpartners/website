window.track = {
  dataLayer: window.dataLayer || [],
  ga: window.ga || function () {},

  pageView: function (page_url) {
    this.ga('send', 'pageview', page_url);
  },

  event: function (category, action, label, value, nonInteraction) {
    var event_params = {
      hitType: 'event',
      eventCategory: category,
      eventAction: action,
      nonInteraction: nonInteraction,
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
  },

  antiFastTrack: function (action, label) {
    this.event('Collection', action, label, false);
  },

  wholesaleTrack: function (action, label) {
    this.event('Wholesale', action, label, false);
  },
};
