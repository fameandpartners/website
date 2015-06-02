module StyleQuiz
  module ApplicationHelper
    def conditional_html(options = {}, &block)
      lang = I18n.locale
      html_class = options[:class]
      html = <<-"HTML".gsub( /^\s+/, '' )
        <!--[if lt IE 7 ]>    <html lang="#{lang}" class="#{lang} #{html_class} ie ie6 no-js"> <![endif]-->
        <!--[if IE 7 ]>       <html lang="#{lang}" class="#{lang} #{html_class} ie ie7 no-js"> <![endif]-->
        <!--[if IE 8 ]>       <html lang="#{lang}" class="#{lang} #{html_class} ie ie8 no-js"> <![endif]-->
        <!--[if IE 9 ]>       <html lang="#{lang}" class="#{lang} #{html_class} ie ie9 no-js"> <![endif]-->
        <!--[if (gte IE 9)|!(IE)]><!--> <html prefix="fb: http://ogp.me/ns/fb#" lang="#{lang}" class="#{lang} #{html_class} no-js"> <!--<![endif]-->
      HTML
      html += capture( &block ) << "\n</html>".html_safe if block_given?
      html.html_safe
    end
  end
end
