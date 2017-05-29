(($) => { 'use strict';

  class Adjust {
    constructor($currencySelect, urls) {
      this.$currencySelect = $currencySelect
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

      this.bindEvents();
    }

    clear() {
      this.$panel.hide();
      this.$buttonPanel.hide();
      this.$panelAmount.val('');
      this.$panelDescription.val('');

      this.$priceTag.html('Please select product details');
      this.$imageTag.html('Please select style and color to see image');
    }

    updatePrice() {
      let url = this.urls.price.replace(/:currency/, this.$currencySelect.val());
      let productIds = $('.product #products_style_name').map((i, el) => $(el).val()).toArray();

      $.getJSON(url, { product_ids: productIds }, function(data) {
        this.$priceTag.html(`$${data.price} ${data.currency}`);
        this.$buttonPanel.show();
      }.bind(this));
    }

    updateImages() {
      let params = $('.product').map((i, el) => {
        let $el = $(el);
        let productID = $('#products_style_name', $el).val();
        let colorID = $('#products_color', $el).val();

        return {
          color_id: colorID,
          product_id: productID
        };
      });

      $.getJSON(this.urls.image, { product_colors: params.toArray() })
        .done(function(data) {
          let $images = data['manual_orders'].map((image) => {
            if (image.url == 'null') {
              return ''
            } else {
              return $('<img>').attr('src', image.url);
            }
          });

          this.$imageTag.html($images);
        }.bind(this)
      );
    }

    bindEvents() {
      this.$button.on('click', () => {
        this.$panel.show();
        this.$panelAmount.prop('readonly', false);
        this.$panelDescription.prop('readonly', false);
        this.$panelOKButton.show();
        this.$button.hide();
        this.$submitButton.prop('disabled', true);
      });

      this.$panelOKButton.on('click', () => {
        let isAmountProper = $.isNumeric($.trim(this.$panelAmount.val()));
        let isDescriptionProper = $.trim(this.$panelDescription.val()).length;

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
      });
    }

  }

  class Product {
    constructor(adjust, templateHtml, urls) {
      this.$product = $(templateHtml).appendTo('#products');
      this.adjust = adjust;
      this.urls = urls;

      this.$optColors = $('<optgroup>', { label: 'Colors' });
      this.$optCustomColors = $('<optgroup>', { label: 'Custom Colors + $16.00' });

      let index = $('.product').index(this.$product)

      this.$styleSelect = $('#products_style_name', this.$product).attr('name', `forms_manual_order[products][${index}][style_name]`);
      this.$colorSelect = $('#products_color', this.$product).attr('name', `forms_manual_order[products][${index}][color]`);
      this.$sizeSelect = $('#products_size', this.$product).attr('name', `forms_manual_order[products][${index}][size]`);
      this.$heightSelect = $('#products_height', this.$product).attr('name', `forms_manual_order[products][${index}][height]`);
      this.$customisationSelect = $('#products_customisations', this.$product).data('name', `forms_manual_order[products][${index}][customisations][]`);

      this.initialize();
    }

    initialize() {
      $('select', this.$product).chosen({ width: '100%' });

      this.$customisationSelect
        .siblings('input')
        .attr('name', this.$customisationSelect.data('name'));

      this.clearFields();
      this.bindEvents();
    }

    clearFields() {
      this.$colorSelect.html('<option></option>')
      this.$optColors.html('')
      this.$optCustomColors.html('')
      this.$sizeSelect.html('<option></option>')
      this.$heightSelect.html('<option></option>')
      this.$customisationSelect.html('<option></option>')

      this.adjust.clear();
    }

    bindEvents() {
      this.$styleSelect.on('change', () => {
        this.clearFields();
        this.updateColors();
        this.updateSizes();
        this.updateHeights();
        this.updateCustomisations();
      });

      this.$colorSelect.on('change', () => {
        if (this.$colorSelect.val()) {
          this.adjust.updateImages();
          this.adjust.updatePrice();
        }
      });

      $('.close', this.$product).on('click', () => this.remove());
    }

    updateCustomisations() {
      let url = this.urls.customisation.replace(/:product_id/, this.$styleSelect.val());

      if (this.$styleSelect.val()) {
        $.getJSON(url, function(data) {
          $.each(data['manual_orders'], function(index, el) {
            let $option = $('<option>', { value: el.id, text: el.name });
            this.$customisationSelect.append($option);
          }.bind(this));

          this.$customisationSelect.trigger("chosen:updated");
        }.bind(this));
      } else {
        this.$customisationSelect.trigger("chosen:updated");
      }
    }

    updateColors() {
      let url = this.urls.color.replace(/:product_id/, this.$styleSelect.val());

      if (this.$styleSelect.val()) {
        $.getJSON(url, function(data) {
          this.$optColors.appendTo(this.$colorSelect);
          this.$optCustomColors.appendTo(this.$colorSelect);

          $.each(data['manual_orders'], function(index, el) {
            let $option = $('<option>', { value: el.id, text: el.name });
            if (el.type === 'color') {
              $option.appendTo(this.$optColors);
            } else {
              $option.appendTo(this.$optCustomColors);
            }
          }.bind(this));

          this.$colorSelect.trigger("chosen:updated");
        }.bind(this));
      } else {
        this.$colorSelect.trigger("chosen:updated");
      }
    }

    updateSizes() {
      let url = this.urls.size.replace(/:product_id/, this.$styleSelect.val());

      if (this.$styleSelect.val()) {
        $.getJSON(url, function(data) {
          $.each(data['manual_orders'], function(index, el) {
            let $option = $('<option>', { value: el.id, text: el.name });
            this.$sizeSelect.append($option);
          }.bind(this));

          this.$sizeSelect.trigger("chosen:updated");
        }.bind(this));
      } else {
        this.$sizeSelect.trigger("chosen:updated");
      }
    }

    updateHeights() {
      let url = this.urls.height.replace(/:product_id/, this.$styleSelect.val());

      if (this.$styleSelect.val()) {
        $.getJSON(url, function(data) {
          $.each(data['manual_orders'], function(index, el) {
            let $option = $('<option>', { value: el.id, text: el.name });
            this.$heightSelect.append($option);
          }.bind(this));

          this.$heightSelect.trigger("chosen:updated");
        }.bind(this));
      } else {
        this.$heightSelect.trigger("chosen:updated");
      }
    }

    remove() {
      this.$styleSelect.off('change');
      this.$colorSelect.off('change');
      this.$product.remove();

      this.adjust.updateImages()
      this.adjust.updatePrice()
    }

  };

  $(document).ready(() => {
    const urls = {
              color: '/fame_admin/manual_orders/colors/:product_id',
              size: '/fame_admin/manual_orders/sizes/:product_id',
            height: '/fame_admin/manual_orders/heights/:product_id',
              image: '/fame_admin/manual_orders/images',
              price: '/fame_admin/manual_orders/price/:currency',
      customisation: '/fame_admin/manual_orders/customisations/:product_id',
    };

    const templateHtml = $('#product_template').html();
    let $currencySelect = $('#forms_manual_order_currency');
    let adjust = new Adjust($currencySelect, urls);
    new Product(adjust, templateHtml, urls);

    $currencySelect.on('change', adjust.updatePrice);

    $('#product_add').on('click', () => {
      new Product(adjust, templateHtml, urls);
    });
  });

})(jQuery);
