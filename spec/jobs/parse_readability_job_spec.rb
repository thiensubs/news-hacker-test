require 'rails_helper'

RSpec.describe ParseReadabilityJob, type: :job do
  describe "#perform_later" do
    it "perform without params" do
      ActiveJob::Base.queue_adapter = :test
      expect {
        ParseReadabilityJob.perform_later('')
      }.to have_enqueued_job
    end
    it "perform with params" do
      expect {
        ParseReadabilityJob.perform_later("22374346", 
          "https://www.buzzfeednews.com/article/alexkantrowitz/how-saudi-arabia-infiltrated-twitter", 
          "b733f0c5-0097-4d82-b245-0b07f7fa1182")
      }.to have_enqueued_job
    end
  end
end
