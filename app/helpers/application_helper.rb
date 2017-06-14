module ApplicationHelper
  def full_title page_title
    base_title = I18n.t "common.base_title"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def admin_full_title page_title
    base_title = I18n.t "common.admin_title"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def increase_one index
    index + Settings.order_increase
  end

  def compare_time_order start_hour, end_hour
    start_hour < end_hour
  end

  def paginate objects, options = {}
    options.reverse_merge! theme: "twitter-bootstrap-3"
    super objects, options
  end

  def count_notification_unread
    if user_signed_in?
      number_noti =  @count_unread_notification
      if number_noti == Settings.notification.number_unread_not_display
        number_noti = ""
      else
        number_noti
      end
    end
  end

  def total_price price, quantity
    price * quantity
  end

  def format_price price
    number_with_delimiter(price.to_i).to_s + t("cart.vnd")
  end

  def bg_unread event
    if event.read == false
      "unread"
    end
  end

  def detail_price cart
    @cart_price = 0
    cart.each do |item|
      @cart_price += item.total_price
    end
    @cart_price
  end

  def selected_lang
    session[:locale]
  end

  def check_domain_status domain
    domain.professed?
  end

  def select_lang
    case selected_lang.to_s
    when Settings.languages.vietnamese.type
      Settings.languages.vietnamese.image
    when Settings.languages.japanese.type
      Settings.languages.japanese.image
    else
      Settings.languages.english.image
    end
  end

  def number_product_in_category_by_domain category, domain
    products = if @domain.present?
      domain.products.by_category category
    else
      category.products
    end
    products.size
  end

  def domain_icon domain
    domain.professed? ? Settings.domain.professed : Settings.domain.secret
  end

  def display_domain_status value
    case value
    when Domain.statuses[:professed]
      html = ""
      html += "<i class=\"glyphicon glyphicon-globe\"></i>"
      html += "<span>#{t "professed"}</span>"
    when Domain.statuses[:secret]
      html = ""
      html += "<i class=\"glyphicon glyphicon-lock\"></i>"
      html += "<span>#{t "secret"}</span>"
    end
  end

  def status_request_shop request_shop
    case
    when request_shop.pending?
      change_status request_shop, "label-warning"
    when request_shop.rejected?
      change_status request_shop, "label-danger"
    when request_shop.approved?
      change_status request_shop, "label-success"
    else
      change_status request_shop, "label-info"
    end
  end

  def change_status request_shop, label_class
    content_tag :span, t("all_status.#{request_shop.status}"),
      class: "label #{label_class}"
  end

  def domain_status
    Domain.statuses.keys.select{|status| status != Domain.statuses.keys[2]}
  end

  def get_user_of_shop user_id, shop_id
    user_of_shop = ShopManager.find_by(user_id: user_id,
      shop_id: shop_id)
  end

  def get_manager_of_shop user_id, shop_id
    manager_of_shop = ShopManager.find_by(user_id: user_id,
      shop_id: shop_id, role: :manager)
  end

  def get_owner_of_shop user_id, shop_id
    owner_of_shop = ShopManager.find_by(user_id: user_id,
      shop_id: shop_id, role: :owner)
  end

  def is_owner_manager_of_shop? shop_id
    get_owner_of_shop(current_user, shop_id).present? ||
      get_manager_of_shop(current_user, shop_id).present?
  end

  def checked_notification_setting? index
    if current_user.notification_settings.present?
      case current_user.notification_settings.values[index]
      when Settings.serialize_false
        return false
      when Settings.serialize_true
        return true
      end
    else
      return true
    end
  end

  def checked_email_setting? index
    if current_user.email_settings.present?
      case current_user.email_settings.values[index]
      when Settings.serialize_false
        return false
      when Settings.serialize_true
        return true
      end
    else
      return true
    end
  end

  def checked_all_notification_setting
    (checked_notification_setting?(Settings.index_zero_in_array) &&
      checked_notification_setting?(Settings.index_one_in_array) &&
      checked_notification_setting?(Settings.index_two_in_array)) ? "checked" : ""
  end

  def checked_all_email_setting
    (checked_email_setting?(Settings.index_zero_in_array) &&
      checked_email_setting?(Settings.index_one_in_array) &&
      checked_email_setting?(Settings.index_two_in_array)) ? "checked" : ""
  end

  def is_member_of_domain? user_id, domain_id
    member_domain = UserDomain.find_by domain_id: domain_id, user_id: user_id
    member_domain.present?
  end
end
