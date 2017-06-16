class Product < ApplicationRecord
  strip_attributes only: [:description, :name]

  acts_as_paranoid
  acts_as_taggable

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]

  def slug_candidates
    [:name, [:name, :id]]
  end

  def should_generate_new_friendly_id?
    slug.blank? || name_changed? || super
  end

  belongs_to :category
  belongs_to :shop
  belongs_to :user

  has_many :order_products
  has_many :reviews, as: :reviewable
  has_many :comments, as: :commentable
  has_many :events, as: :eventable
  has_many :orders, through: :order_products
  has_many :product_domains
  has_many :domains, through: :product_domains

  enum status: {active: 0, inactive: 1}
  mount_uploader :image, ProductImageUploader
  mount_base64_uploader :image, ProductImageUploader
  validates :name, presence: true, length: {maximum: Settings.product.max_name}
  validates :description, presence: true, length: {maximum: Settings.product.max_description}
  validate :image_size
  validate :start_hour_before_end_hour
  validates :price, presence: true,
    numericality: {greater_than: Settings.min_price,
    less_than_or_equal_to: Settings.product.max_price}

  delegate :name, to: :shop, prefix: :shop, allow_nil: true
  delegate :avatar, to: :shop, prefix: :shop
  delegate :slug, to: :shop, prefix: true
  delegate :name, to: :category, prefix: true

  scope :by_date_newest, ->{order created_at: :desc}
  scope :by_active, ->{where status: :active}
  scope :top_products, -> do
    by_active.by_date_newest.limit Settings.index.max_products
  end
  scope :by_category, -> category{where category_id: category}

  scope :by_category, ->category do
    where category_id: category.id
  end

  scope :in_domain, -> domain_id do
    joins(:product_domains)
      .where "product_domains.domain_id = ?", domain_id
  end

  private
  def image_size
    max_size = Settings.pictures.max_size
    if image.size > max_size.megabytes
      errors.add :image, I18n.t("pictures.error_message", max_size: max_size)
    end
  end

  def start_hour_before_end_hour
    unless self
      if start_hour > end_hour
        errors.add :start_hour, I18n.t("error_message_time")
      end
    end
  end
end
