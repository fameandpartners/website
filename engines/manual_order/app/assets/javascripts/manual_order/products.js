(function ($) { 'use strict';

  function Adjust($currencySelect, urls) {
    this.$currencySelect = $currencySelect;
    this.urls = urls;

    this.$panel = $('.adjust-panel');
    this.$buttonPanel = $('.adjust-btn-panel');

    this.$button = $('.adjust-btn', this.$buttonPanel);
    this.$panelAmount = $('.amount', this.$panel);
    this.$panelDescription = $('.description', this.$panel);
    this.$panelOKButton = $('.ok-button', this.$panel);

    this.$submitButton = $('.submit_btn');

    this.$priceTag = $('h4.price');
    this.$imageTag = $('h4.product_image');

    this.clear = function() {
      this.$panel.hide();
      this.$buttonPanel.hide();
      this.$panelAmount.val('');
      this.$panelDescription.val('');

      this.$priceTag.html('Please select product details');
      this.$imageTag.html('Please select style and color to see image');
    };

    this.updatePrice = function() {
      var url = this.urls.price.replace(/:currency/, this.$currencySelect.val());
      var productIds = $('.product #products_style_name').map(function(i, el) {
        return $(el).val();
      }).toArray();

      $.getJSON(url, { product_ids: productIds }, function(data) {
        this.$priceTag.html('$' + data.price + ' ' + data.currency);
        this.$buttonPanel.show();
      }.bind(this));
    }.bind(this);

    this.updateImages = function() {
      var params = $('.product').map(function(i, el) {
        var $el = $(el);
        var productID = $('#products_style_name', $el).val();
        var colorID = $('#products_color', $el).val();
        var fabricID = $('#products_fabric', $el).val();


        return {
          color_id: colorID,
          product_id: productID,
          fabric_id: fabricID
        };
      });

      $.getJSON(this.urls.image, { product_colors: params.toArray() }).done(function(data) {
        var $images = data['manual_orders'].map(function (image) {
          if (image.url == 'null') {
            return '';
          } else {
            return $('<img>').attr('src', image.url);
          }
        });

        this.$imageTag.html($images);
      }.bind(this));
    };

    this.$button.on('click', function () {
      this.$panel.show();
      this.$panelAmount.prop('readonly', false);
      this.$panelDescription.prop('readonly', false);
      this.$panelOKButton.show();
      this.$button.hide();
      this.$submitButton.prop('disabled', true);
    }.bind(this));

    this.$panelOKButton.on('click', function() {
      var isAmountProper = $.isNumeric($.trim(_this.$panelAmount.val()));
      var isDescriptionProper = $.trim(_this.$panelDescription.val()).length;

      if (isAmountProper && isDescriptionProper) {
        this.$button.show();
        this.$panelOKButton.hide();
        this.$panelAmount.prop('readonly', true);
        this.$panelDescription.prop('readonly', true);
        this.$submitButton.prop('disabled', false);
      } else {
        this.$button.show();
        this.$panelOKButton.hide();
        this.$panel.hide();
        this.$submitButton.prop('disabled', false);
        window.alert('Please input correct amount value and description');
      }
    }.bind(this));
  }

  function Product(adjust, templateHtml, urls) {
    this.$product = $(templateHtml).appendTo('#products');
    this.adjust = adjust;
    this.urls = urls;
    this.index = $('.product').index(this.$product);

    this.$optColors = $('<optgroup>', { label: 'Colors' });
    this.$optFabrics = $('<optgroup>', { label: 'Fabrics' });
    this.$optCustomColors = $('<optgroup>', { label: 'Custom Colors + $16.00' });

    this.$styleSelect = $('#products_style_name', this.$product).attr('name', 'forms_manual_order[products][' + this.index + '][style_name]');
    this.$colorSelect = $('#products_color', this.$product).attr('name', 'forms_manual_order[products][' + this.index + '][color]');
    this.$fabricSelect = $('#products_fabric', this.$product).attr('name', 'forms_manual_order[products][' + this.index + '][fabric]');
    this.$sizeSelect = $('#products_size', this.$product).attr('name', 'forms_manual_order[products][' + this.index + '][size]');
    this.$heightSelect = $('#products_height', this.$product).attr('name', 'forms_manual_order[products][' + this.index + '][height]');
    this.$customisationSelect = $('#products_customisations', this.$product).attr('name', 'forms_manual_order[products][' + this.index + '][customisations][]');

    this.clearFields = function() {
      this.$colorSelect.html('<option></option>');
      this.$optColors.html('');
      this.$optFabrics.html('');
      this.$optCustomColors.html('');
      this.$sizeSelect.html('<option></option>');
      this.$heightSelect.html('<option></option>');
      this.$customisationSelect.html('<option></option>');

      this.adjust.clear();
    };

    this.updateCustomisations = function() {
      var url = this.urls.customisation.replace(/:product_id/, this.$styleSelect.val());

      if (this.$styleSelect.val()) {
        $.getJSON(url, function(data) {
          $.each(data['manual_orders'], function(index, el) {
            var $option = $('<option>', { value: el.id, text: el.name });
            this.$customisationSelect.append($option);
          }.bind(this));

          this.$customisationSelect.trigger("chosen:updated");
        }.bind(this));
      } else {
        this.$customisationSelect.trigger("chosen:updated");
      }
    };

    this.updateColors = function() {
      var url = this.urls.color.replace(/:product_id/, this.$styleSelect.val());

      if (this.$styleSelect.val()) {
        $.getJSON(url, function(data) {
          if (data["manual_orders"].length < 1) {
            $("#products_color_chosen").hide();
          }
          else {
            $("#products_color_chosen").show();
            this.$optColors.appendTo(this.$colorSelect);
            this.$optCustomColors.appendTo(this.$colorSelect);

            $.each(data['manual_orders'], function(index, el) {
              var $option = $('<option>', { value: el.id, text: el.name });
              if (el.type === 'color') {
                $option.appendTo(this.$optColors);
              } else {
                $option.appendTo(this.$optCustomColors);
              }
            }.bind(this));

            this.$colorSelect.trigger("chosen:updated");
          }
        }.bind(this));
      } else {
        this.$colorSelect.trigger("chosen:updated");
      }
    };

    this.updateFabrics = function() {
      var url = this.urls.fabric.replace(/:product_id/, this.$styleSelect.val());

      url += '?currency=' + $('#forms_manual_order_currency').val();

      if (this.$styleSelect.val()) {
        $.getJSON(url, function(data) {
          if (data["manual_orders"].length < 1) {
            $("#products_fabric_chosen").hide();
          }
          else {
            $("#products_fabric_chosen").show();
            this.$optFabrics.appendTo(this.$fabricSelect);

            $.each(data['manual_orders'], function(index, el) {
              var $option = $('<option>', { value: el.id, text: el.name });
                $option.appendTo(this.$optFabrics);
            }.bind(this));

            this.$fabricSelect.trigger("chosen:updated");
          }
        }.bind(this));
      } else {
        this.$fabricSelect.trigger("chosen:updated");
      }
    };

    this.updateSizes = function() {
      var url = this.urls.size.replace(/:product_id/, this.$styleSelect.val());

      if (this.$styleSelect.val()) {
        $.getJSON(url, function(data) {
          $.each(data['manual_orders'], function(index, el) {
            var $option = $('<option>', { value: el.id, text: el.name });
            this.$sizeSelect.append($option);
          }.bind(this));

          this.$sizeSelect.trigger("chosen:updated");
        }.bind(this));
      } else {
        this.$sizeSelect.trigger("chosen:updated");
      }
    };

    this.updateHeights = function() {
      var url = this.urls.height.replace(/:product_id/, this.$styleSelect.val());

      if (this.$styleSelect.val()) {
        $.getJSON(url, function(data) {
          $.each(data['manual_orders'], function(index, el) {
            var $option = $('<option>', { value: el.id, text: el.name });
            this.$heightSelect.append($option);
          }.bind(this));

          this.$heightSelect.trigger("chosen:updated");
        }.bind(this));
      } else {
        this.$heightSelect.trigger("chosen:updated");
      }
    };


    this.remove = function() {
      this.$styleSelect.off('change');
      this.$colorSelect.off('change');
      this.$fabricSelect.off('change');
      this.$product.remove();

      this.adjust.updateImages();
      this.adjust.updatePrice();
    };

    $('select', this.$product).chosen({ width: '100%' });

    this.clearFields();

    this.$styleSelect.on('change', function() {
      this.clearFields();
      this.updateColors();
      this.updateFabrics();
      this.updateSizes();
      this.updateHeights();
      this.updateCustomisations();
    }.bind(this));

    this.$colorSelect.on('change', function() {
      if (this.$colorSelect.val()) {
        this.adjust.updateImages();
        this.adjust.updatePrice();
      }
    }.bind(this));

    this.$fabricSelect.on('change', function() {
      if (this.$fabricSelect.val()) {
        this.adjust.updateImages();
        this.adjust.updatePrice();
      }
    }.bind(this));

    $('.close', this.$product).on('click', this.remove.bind(this));
  }

  $(document).ready(function() {
    var urls = {
      color: '/fame_admin/manual_orders/colors/:product_id',
      fabric: '/fame_admin/manual_orders/fabrics/:product_id',
      size: '/fame_admin/manual_orders/sizes/:product_id',
      height: '/fame_admin/manual_orders/heights/:product_id',
      image: '/fame_admin/manual_orders/images',
      price: '/fame_admin/manual_orders/price/:currency',
      customisation: '/fame_admin/manual_orders/customisations/:product_id'
    };

    var templateHtml = $('#product_template').html();
    var $currencySelect = $('#forms_manual_order_currency');
    var adjust = new Adjust($currencySelect, urls);

    new Product(adjust, templateHtml, urls);

    $currencySelect.on('change', adjust.updatePrice);

    $('#product_add').on('click', function() {
      new Product(adjust, templateHtml, urls);
    });
  });
})(jQuery);
