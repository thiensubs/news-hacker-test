require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "GET index" do
    it "assigns something" do
    end

    it "renders the index template" do
      get :index,  params: {}
      expect(response).to render_template("index")
    end
  end
end
