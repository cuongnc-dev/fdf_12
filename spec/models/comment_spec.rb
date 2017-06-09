require "rails_helper"

RSpec.describe Comment, type: :model do
  context "associations" do
    it {is_expected.to belong_to :user}
    it {is_expected.to belong_to :commentable}
  end

  context "delegates" do
    it {is_expected.to delegate_method(:name).to(:user).with_prefix :user}
    it {is_expected.to delegate_method(:avatar).to(:user).with_prefix :user}
  end

  context "validate" do
    it {is_expected.to validate_length_of(:content)
      .is_at_least(Settings.min_content_of_comment)
      .is_at_most(Settings.max_content_of_comment)}
  end

  describe ".add_name_image_of_user_scope" do
    let(:user) {FactoryGirl.create :user}
    let(:category) {FactoryGirl.create :category}
    let(:shop) {FactoryGirl.create :shop}

    it "test scope add_name_image_of_user" do
      product = Product.create name: "Product", description: "Product", price: 20000,
        image: "Product", status: 0, category_id: category.id, shop_id: shop.id,
        user_id: user.id
      comment = Comment.create content: "Test comment", user_id: user.id,
        commentable_type: "Product", commentable_id: product.id
      expect(Comment.add_name_image_of_user).to be == [comment]
    end
  end
end
