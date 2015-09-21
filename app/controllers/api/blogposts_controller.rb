require 'rest-client'

class Api::BlogpostsController < ApplicationController
  def index
    xml = RestClient.get('http://blog.fameandpartners.com/rss')
    doc = Nokogiri::XML(xml)

    @blogs = []
    doc.search('//item').each do |item|
      blog = {}
      blog[:title]       = item.search('title').text
      blog[:description] = item.search('description').text
      blog[:link]        = item.search('link').text
      @blogs << blog
    end

    render json: @blogs.to_json
  end
end
