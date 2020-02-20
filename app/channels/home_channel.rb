class HomeChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "content_news_#{params[:job_id]}"
  end

  def unsubscribed
    # stop_all_streams
    # Any cleanup needed when channel is unsubscribed
  end
end
