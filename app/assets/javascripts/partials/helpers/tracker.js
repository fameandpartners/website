window.track = {
  dataLayer: window.dataLayer || [],
  ga: window.ga || function () {},

  pageView: function (url) {
    window.dataLayer.push({
      event: 'Page Loaded',
      eventDetail: { url },
    });
  },

  event: function (category, action, label) {
    window.dataLayer.push({
      event: action,
      eventDetail: { category, label },
    });
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
    this.event('Collection', action, label);
  },

  wholesaleTrack: function (action, label) {
    this.event('Wholesale', action, label);
  },

  internshipTrack: function (action, label) {
    this.event('Internship', action, label);
  },

  bridesmaidTeaserTrack: function (action, label) {
    this.event('BridesmaidTeaser', action, label);
  },
};
