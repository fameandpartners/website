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

  quizOpened: function (label) {
    this.event('Style Quiz', 'Opened', label);
  },

  quizClickedNext: function (label) {
    this.event('Style Quiz', 'ClickedNext', label);
  },

  quizFinished: function (label) {
    this.event('Style Quiz', 'Finished', label);
  },

  inviteToPayOpened: function () {
    this.event('InviteToPay', 'Opened');
  },

  inviteToPaySent: function () {
    this.event('InviteToPay', 'Sent');
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

  internshipTrack: function (action, label) {
    this.event('Internship', action, label, false);
  },

  bridesmaidTeaserTrack: function (action, label) {
    this.event('BridesmaidTeaser', action, label, false);
  },
};
