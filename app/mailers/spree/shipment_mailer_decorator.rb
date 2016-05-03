Spree::ShipmentMailer.class_eval do
  add_template_helper(OrdersHelper)

  def shipped_email(shipment, resend = false)
    byebug
    @shipment = shipment.is_a?(Spree::Shipment) ? shipment : Spree::Shipment.find(shipment)
    subject = (resend ? "[#{t(:resend).upcase}] " : '')
    subject += "Hey babe, your dress is on it's way - Order: ##{@shipment.order.number}"
    #mail(:to => @shipment.order.email, :from => from_address, :subject => subject)

    order_presenter = Orders::OrderPresenter.new(@shipment.order, @shipment.line_items)
    line_items = extract_line_items

    Marketing::CustomerIOEventTracker.new.track(
      user,
      'shipment_mailer',
      email_to:              @shipment.order.email,
      from:                  from_address,
      subject:               subject,
      date:                  Date.today.to_formatted_s(:long),
      name:                  order.first_name.rstrip,
      shipment_method_name:  @shipment.shipping_method.name,
      shipment_tracking:     @shipment.tracking,



      number:             order_presenter.number,
      site:               order_presenter.site_version,
      total_items:        order_presenter.total_items,
      promotion:          order_presenter.promotion?,
      promocode:          order_presenter.promo_codes.join(', '),
      line_items:         line_items,
      customer_notes:     order_presenter.customer_notes?,
      customer_note_data: order_presenter.customer_notes,
      customer:           order_presenter.name,
      phone:              order_presenter.phone_number,
      shipping_address:   order_presenter.shipping_address,
      factory:            factory,
      display_total:      order_presenter.display_total,
      currency:           order_presenter.currency
    )
    rescue StandardError => e
      NewRelic::Agent.notice_error(e)
    end

  end

  def extract_line_items
    order_presenter.line_items.collect do |item|
      {
        style_num:        item.style_number,
        sku:              item.sku,
        line_item_id:     item.id,
        product_number:   item.product_number,
        size:             item.size,
        adjusted_size:    item.country_size,
        color:            item.colour_name,
        height:           item.height,
        quantity:         item.quantity,
        factory:          item.factory,
        deliver_date:     item.projected_delivery_date,
        express_making:   item.making_options.present? ? item.making_options.map{|option| option.name.upcase }.join(', ') : "",
        image_url:        item.image? ? item.image_url : ''
      }.merge(
         # Convert each element of the customisations array
         # to an explicit hash key and child hash.
         #
         # Customizations is an array , currently customerio does not support nested array in json properly and they are working on it
         # that's why the json receive on customerio is not formatted correctly which lead to failed emails
         # a hacking solution is pull out all elements in customizations array to seperate elements so customerio can read correctly
         # Current output will be line_items[{... customizations: []....customizations_0: [], customizations_1: [], customizations_2: []...}, {}]
         #
         # e.g. Where we would like to use an array;
         # :customizations=>[{:name=>"N/A", :url=>nil}, {:name=>"Cool", :url=>nil} ]
         # we must use merge a hash to the original result
         # :customizations_0=>{:name=>"N/A", :url=>nil},
         # :customizations_1=>{:name=>"Cool", :url=>nil},
        item.customisations.each_with_index.map do |(name, image_url), idx|
          ["customizations_#{idx}".to_sym, {name: name, url: image_url}]
        end.to_h
      )
    end
  end


end



Marketing::CustomerIOEventTracker.new.track(
  user,
  'order_production_order_email',
  email_to:           delivery_email,
  subject:            subject,
  number:             order_presenter.number,
  site:               order_presenter.site_version,
  total_items:        order_presenter.total_items,
  promotion:          order_presenter.promotion?,
  promocode:          order_presenter.promo_codes.join(', '),
  line_items:         line_items,
  customer_notes:     order_presenter.customer_notes?,
  customer_note_data: order_presenter.customer_notes,
  customer:           order_presenter.name,
  phone:              order_presenter.phone_number,
  shipping_address:   order_presenter.shipping_address,
  factory:            factory,
  display_total:      order_presenter.display_total,
  currency:           order_presenter.currency
)
rescue StandardError => e
NewRelic::Agent.notice_error(e)
end



- order = Orders::OrderPresenter.new(@shipment.order, @shipment.line_items)
- th_style = "color: #999; font-size: 13px; text-align: left; font-weight: 400; padding: 4px 6px; border-top: 1px solid #d6d6d6; border-bottom: 1px solid #d6d6d6;"
- p_td_style = "color: #666; font: 400 13px/1.5 'Helvetica Neue', 'HelveticaNeue', Helvetica, Arial, sans-serif;"
- td_style = "border-top: 1px solid #d6d6d6; padding: 4px 6px;"
- subtle_link = "color: #666;  text-decoration: none; font: 400 13px/1.5 'Helvetica Neue', 'HelveticaNeue', Helvetica, Arial, sans-serif;"
table align="center" border="0" cellpadding="0" cellspacing="0" width="600px"
  tbody
    tr
      td width="38"
      td
        table align="center" border="0" cellpadding="0" cellspacing="0" width="100%"
          tbody
            tr
              td height="27"
            tr
              td.date style="color: #999; font: 400 12px/1.5 'Helvetica Neue', 'HelveticaNeue', Helvetica, Arial, sans-serif;"
                = Date.today.to_formatted_s(:long)
            tr
              td height="20"
            tr
              td style="#{p_td_style}"
                ' Hey #{order.first_name.rstrip},
            tr
              td height="10"
            tr
              td style="#{p_td_style}"
                p style="margin: 0;"
                | We have some great news. Your dress has now been shipped and is on it's way to you.
            tr : td height="10"
            tr
              td
                p style="#{p_td_style}"
                  ' Here's your tracking number:
            tr
              td
                p style="margin: 0; color: #000; text-transform: uppercase; font: 700 13px/1.5 'Helvetica Neue', 'HelveticaNeue', Helvetica, Arial, sans-serif;"
                  = @shipment.shipping_method.name
                  '
                  = @shipment.tracking
            tr : td height="20"

            tr
              td
                table align="center" border="0" cellpadding="0" cellspacing="0" width="100%"
                  thead
                    th style="#{th_style}" Dress
                    th style="#{th_style}" SKU
                    th style="#{th_style}" Color
                    th style="#{th_style}" Size
                  tbody
                    - order.line_items.each do |item|
                      tr
                        td style="color: #000; font-size: 13px; text-align: left; font-weight: 400; padding: 7px 6px; vertical-align: top;"
                          div style="font-weight: 700" =' item.style_name

                        td style="#{p_td_style}" =' item.style_number
                        td style="#{p_td_style}" =' item.colour.presentation
                        td style="#{p_td_style}" =' item.country_size
            tr : td height="30"
            tr
              td
                p style="#{p_td_style}"
                  ' To track your dress' journey, simply go to:
                  br
                  a href=shipment_tracking_url(@shipment)
                    = shipment_tracking_url(@shipment)
            tr : td height="10"
            tr
              td style="#{p_td_style}"
                p style="margin: 0;"
                  ' If you can't find your package there we may have used an alternative shipping option, in which case simply email:
                  a href="mailto:team@fameandpartners.com"
                    ' team@fameandpartners.com
                  ' to find out how to track your dress.
            tr : td height="10"
            tr
              td style="#{p_td_style}"
                p style="margin: 0;"
                  ' We know you will be a total #famebabe in your new
                  ' dress, so feel free to tag us when you wear it in
                  ' your social channels - @fameandpartners - we love
                  ' to see how our customers style their total look.

            tr : td height="30"

            tr
              td style="color: #000; font: 400 italic 16px/1.2 Georgia, 'Trebuchet MS', 'Times New Roman', sans-serif;"
                ' Team Fame xx

            tr : td height="40"
            tr
              td style="color: #666; font: 400 13px/1.5 'Helvetica Neue', 'HelveticaNeue', Helvetica, Arial, sans-serif;"
                a href="http://fameandpartners.com/faqs" style="#{subtle_link}" FAQ
                '  |
                a href="mailto:team@fameandpartners.com" style="#{subtle_link}"
                  ' team@fameandpartners.com
            tr
              td height="27"
      td width="38"
