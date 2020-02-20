class HomeController < ApplicationController
  def index
    if params[:page].present?
      ParseNewsJob.perform_later(params[:page], params[:channel_id])
    else
      @job_id = ParseNewsJob.perform_later().job_id 
    end
  end
end
