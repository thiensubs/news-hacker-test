class HomeChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    if params[:job_id].present?
      stream_from "content_news_#{params[:job_id]}" 
    else
      reject
    end
  end

  def unsubscribed
    # stop_all_streams
    # Any cleanup needed when channel is unsubscribed
  end
end
