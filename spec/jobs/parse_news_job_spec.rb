require 'rails_helper'

RSpec.describe ParseNewsJob, type: :job do
  describe "#perform_later" do
    it "perform without params" do
      ActiveJob::Base.queue_adapter = :test
      expect {
        ParseNewsJob.perform_later('')
      }.to have_enqueued_job
    end
    it "perform with params" do
      expect {
        ParseNewsJob.perform_later('2', '902232bb-eeda-42ac-9468-f253a32918bc')
      }.to have_enqueued_job
    end
  end
end
