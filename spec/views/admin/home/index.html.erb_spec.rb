require "rails_helper"

RSpec.describe "admin/home/index.html.erb", type: :view do
  let!(:products) {FactoryGirl.create_list(:product, 10)}

  it "should display home index" do
    @users = User.by_date_newest
      .take Settings.admin.dashboard.max_items
    @shops = Shop.by_date_newest
      .take Settings.admin.dashboard.max_items
    @products = Product.by_date_newest
      .take Settings.admin.dashboard.max_items
    render
    expect(rendered).to include @users.first.name
    expect(rendered).to include @shops.first.name
    expect(rendered).to include @products.first.name
  end
end
