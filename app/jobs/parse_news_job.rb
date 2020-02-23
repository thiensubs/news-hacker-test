require "ostruct"
require 'open-uri'

class ParseNewsJob < ApplicationJob
  queue_as :default
  TTL = 5
  URL_NEWS = "https://news.ycombinator.com/best"
  def perform(*args)
    if Rails.cache.fetch('data').present? && args.size ==0
      news_list = Rails.cache.fetch('data')
    else
      source = if args.size ==0
        URI.open(URL_NEWS).read
      else
        page = args[0].to_i
        URI.open("#{URL_NEWS}?p=#{page}").read
      end

      #Query data with nokogiri syntax
      doc = Nokogiri::HTML.parse(source)
      table = doc.css('#hnmain')
      tr_contents = table.search('tr').search('table.itemlist').search('tr')
      athing_list = tr_contents.select{|tr| ["athing"].include? tr[:class]}
      news_list = []
      info_list = tr_contents.select{|tr| tr[:class]==nil}

      ## make data for cache and render html to broadcast.
      athing_list.each_with_index do |athing, index|
        sitestr = athing.search('.sitestr').text.squish
        title = athing.search('.rank').text.squish + athing.search('.storylink').text.squish 
        link = athing.search('.storylink').attr('href').value rescue ' '
        hash_temp = { id: athing[:id], title: title, info: info_list[index].text.squish, site: sitestr, link:  link}
        news = OpenStruct.new(hash_temp)
        news_list << news
      end
      Rails.cache.write('data', news_list, expires_in: TTL.minutes) if args.size ==0
    end
    #render html 
    data = ApplicationController.render(partial: 'partials/new', :collection => news_list, cached: true)
    list_id_process = news_list.map{|e| e.id}
    list_link_process = news_list.map{|e| e.link}
    job_id = args.size==0 ? self.job_id : args[1]
    Rails.logger.info "[ActionCable] Sent data ws via: content_news_#{job_id}"
    # broadcast to the channel.
    if args.size ==0
      ActionCable.server.broadcast "content_news_#{job_id}", data: data, message: 'HTML View'
    else
      ActionCable.server.broadcast "content_news_#{job_id}", data: data, message: 'HTML View', page: page
    end
    #Parse readability for each items in news.
    news_list.each do |e|
      ParseReadabilityJob.perform_later(e.id, e.link, job_id)
    end
  end
end
