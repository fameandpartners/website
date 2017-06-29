(function(window) {

  // Newsletter subscription
  var NewsletterSubscriberOnPage,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  window.page || (window.page = {});

  window.page.NewsletterSubscriberOnPage = NewsletterSubscriberOnPage = (function() {
    function NewsletterSubscriberOnPage(opts) {
      if (opts == null) {
        opts = {};
      }
      this.success = bind(this.success, this);
      this.failure = bind(this.failure, this);
      this.handler = bind(this.handler, this);
      this.submit = bind(this.submit, this);
      this.url = bind(this.url, this);
      this.campaign = opts.campaign || 'home';
      this.$form = $('.' + opts.form);
      this.$form.on('submit', this.submit);
    }

    NewsletterSubscriberOnPage.prototype.url = function() {
      return this.$form.attr('action') + "?callback=?";
    };

    NewsletterSubscriberOnPage.prototype.submit = function(e) {
      var $this, email, url, form_name, service;
      e.preventDefault();
      $this = $(e.target);
      url = $('input[name="url"]', $this).val();
      form_name = $('input[name="form_name"]', $this).val();
      email = $('input[name="email"]', $this).val();
      service = $('input[name="service"]', $this).val();
      return $.ajax({
        method: 'POST',
        dataType: 'json',
        url: url,
        async: true,
        data: {
          email: email,
          service: service,
          form_name: form_name
        },
        success: this.handler,
        error: function () {
            this.signupFailure
        }
      });
    };

    NewsletterSubscriberOnPage.prototype.handler = function(data) {
      if (data.status === 'done') {
        return this.success(data);
      } else {
        return this.failure(data);
      }
    };

    NewsletterSubscriberOnPage.prototype.failure = function() {
      var message = 'Please enter a valid email.';

      $('.js-email-error-message-body').text(message);
      $('.js-email-error-message').removeClass('hide');
    };

    NewsletterSubscriberOnPage.prototype.signupFailure = function() {
      var message = 'We had an issue saving your email.';

      $('.js-email-error-message-body').text(message);
      $('.js-email-error-message').removeClass('hide');
    };

    NewsletterSubscriberOnPage.prototype.success = function() {
      $('.js-email-error-message').addClass('hide');
      $('.newsletter-signup-form, .js-email-success-message').toggleClass('hide');
    };

    return NewsletterSubscriberOnPage;

  })();

})(window)
