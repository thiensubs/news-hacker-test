require "ostruct"
require 'open-uri'
class ParseReadabilityJob < ApplicationJob
  queue_as :default
  TTL = 4
  def perform(*args)
    return if args.size==0
    link_to_get = args[1]
    channel_to_broadcast = args[2]
    id_to_cache = args[0]

    if Rails.cache.fetch("datum_id_#{id_to_cache}").present?
      datum = Rails.cache.fetch("datum_id_#{id_to_cache}")
    else
      source = URI.open(link_to_get).read
      rbody = Readability::Document.new(source, :tags => %w[div p img a], 
                :attributes => %w[src href], :remove_empty_nodes => false)
      hash_temp = {image_meta: rbody.images.first, content: Readability::Document.new(source).content}
      datum = OpenStruct.new(hash_temp)
      Rails.cache.write("datum_id_#{id_to_cache}", datum, expires_in: TTL.minutes)
    end
    ActionCable.server.broadcast "content_news_#{channel_to_broadcast}", data: datum, 
              message: 'Each View', id: id_to_cache
  end
end
