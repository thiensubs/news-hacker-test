require 'rails_helper'

RSpec.describe HomeChannel, type: :channel do
  describe "#reject subscription" do
    it "rejects subscribes without job_id" do
      subscribe
      expect(subscription).to be_rejected
    end
    it "rejects subscription with job it set nil" do
      stub_connection job_id: nil
      subscribe
      expect(subscription).to be_rejected
    end
  end
  it "successfully subscribes" do
    subscribe(job_id: '865d8dd4-c326-425b-a1d7-6666fb290a9e')
    expect(subscription).to be_confirmed
  end
end
