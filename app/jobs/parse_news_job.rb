require "ostruct"
require 'open-uri'

class ParseNewsJob < ApplicationJob
  queue_as :default
  TTL = 5
  URL_NEWS = "https://news.ycombinator.com/best"
  def perform(*args)
    if Rails.cache.fetch('data').present? && args.size ==0
      @data = Rails.cache.fetch('data')
    else
      source = if args.size ==0
        URI.open(URL_NEWS).read
      else
        URI.open("#{URL_NEWS}?p=#{args[0].to_i}").read
      end
      doc = Nokogiri::HTML.parse(source)
      table = doc.css('#hnmain')
      news_list = []
      tr_contents = table.search('tr').search('table.itemlist').search('tr')
      athing_list = tr_contents.select{|tr| ["athing"].include? tr[:class]}

      info_list = tr_contents.select{|tr| tr[:class]==nil}
      athing_list.each_with_index do |athing, index|
        sitestr = athing.search('.sitestr').text.squish
        title = athing.search('.storylink').text.squish 
        link = athing.search('.storylink').attr('href') rescue ' '
        hash_temp = { id: athing[:id], title: title, info: info_list[index].text.squish, site: sitestr, link:  link}
        news = OpenStruct.new(hash_temp)
        news_list << news
      end

      @data = ApplicationController.render(partial: 'partials/new', :collection => news_list, cached: true)
      Rails.cache.write('data', @data, expires_in: TTL.minutes) if args.size ==0
    end

    if args.size ==0
      Rails.logger.info "[ActionCable] Sent data ws via: content_news_#{self.job_id}"
      ActionCable.server.broadcast "content_news_#{self.job_id}", data: @data, message: 'HTML View'
    else
      ActionCable.server.broadcast "content_news_#{args[1]}", data: @data, message: 'HTML View', page: args[0]
      Rails.logger.info "[ActionCable] Sent data ws via: content_news_#{args[1]}"
    end
  end
end
