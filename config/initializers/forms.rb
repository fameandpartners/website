ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  html = %(<div class="field_with_errors">#{html_tag}</div>).html_safe
  # add nokogiri gem to Gemfile

  form_fields = [
    'textarea',
    'input',
    'select'
  ]

  elements = Nokogiri::HTML::DocumentFragment.parse(html_tag).css "label, " + form_fields.join(', ')

  elements.each do |e|
    # TODO: Clean up all this logic two more conditions based on data attributes
    # were added to make wedding_atelier work because all the structural changes (HTML)
    # that this adds to the tags with errors.
    if e.get_attribute('data-no-error')
      html = html_tag
      next
    end
    if e.node_name.eql? 'label'
      html = %(<div class="control-group has-warning">#{e}</div>).html_safe
    elsif form_fields.include? e.node_name
      if instance.error_message.kind_of?(Array)
        if e.get_attribute('data-outside-error')
          html = %(#{html_tag}<div class="control-group has-warning outside-input-error"><span class="help-inline">&nbsp;#{instance.error_message.uniq.join(', ')}</span></div>).html_safe
        else
          html = %(<div class="control-group has-warning">#{html_tag}<span class="help-inline">&nbsp;#{instance.error_message.uniq.join(', ')}</span></div>).html_safe
        end
      else
        html = %(<div class="control-group has-warning">#{html_tag}<span class="help-inline">&nbsp;#{instance.error_message}</span></div>).html_safe
      end
    end
  end
  html
end
