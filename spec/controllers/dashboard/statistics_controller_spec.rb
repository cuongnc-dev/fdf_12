require "rails_helper"

RSpec.describe Dashboard::StatisticsController, type: :controller do
  let!(:user) {FactoryGirl.create :user}

  describe "GET #index" do
    before do
      allow(controller).to receive(:check_user_status_for_action).and_return nil
      allow(controller).to receive(:current_user).and_return user
      sign_in user
    end

    it "success index" do
      get :index
      expect(response).to have_http_status :success
    end
  end
end
