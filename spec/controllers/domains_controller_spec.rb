require "rails_helper"

RSpec.describe DomainsController, type: :controller do
  let!(:user) {FactoryGirl.create :user}
  let!(:domain) {FactoryGirl.create :domain}
  let!(:shop) {FactoryGirl.create :shop}
  let!(:category) {FactoryGirl.create :category}

  before do
    allow(controller).to receive(:authenticate_user!).and_return true
    allow(controller).to receive(:current_user).and_return user
    sign_in user
  end

  describe "GET #index" do
    it "success" do
      get :index
      expect(response).to have_http_status :success
    end
  end

  describe "GET #new" do
    it "success" do
      expect(response).to have_http_status :success
    end
  end

  describe "GET #show" do
    before do
      ShopDomain.create domain_id: domain.id, shop_id: shop.id, status: 1
      Product.create name: "Product", description: "Description", price: 20000,
        status: 0, category_id: category.id, shop_id: shop.id, user_id: user.id
      get :show, params: {id: domain.id}
    end

    it "success" do
      expect(response).to have_http_status :success
    end
  end

  describe "PATCH #update" do
    before do
      request.env["HTTP_REFERER"] = "http://localhost:3000/domains/index"
    end

    it "update success" do
      patch :update, params: {id: domain.id, status: :secret}
      domain.reload
      expect(domain.status).to eq "secret"
    end

    it "update fail" do
      patch :update, params: {id: domain.id, status: nil}
      domain.reload
      expect(flash[:danger]).to be_present
    end
  end

  describe "POST #create" do
    before do
      request.env["HTTP_REFERER"] = "http://localhost:3000/domains/index"
      @before_count = Domain.count
    end

    it "save success" do
      post :create, params: {domain: FactoryGirl.attributes_for(:domain, name: "Domain",
        status: :secret, owner: user.id)}
      expect(Domain.count).not_to eq @before_count
    end

    it "cannot save" do
      post :create, params: {domain: FactoryGirl.attributes_for(:domain, name: nil,
        status: :secret, owner: user.id)}
      expect(flash[:danger]).to be_present
    end

    it "test #active_account before create" do
      user.update_attribute :status, :wait
      user.reload
      post :create, params: {domain: FactoryGirl.attributes_for(:domain, name: nil,
        status: :secret, owner: user.id)}
      expect(flash[:danger]).to be_present
    end
  end
end
