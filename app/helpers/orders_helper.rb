module OrdersHelper
  def shop_domain_select shop
    shop_manager = ShopManager.find_by user_id: current_user.id, shop_id: shop.id
    if shop_manager.present?
      if shop_manager.owner?
        domain_ids = @shop.shop_domains.select{|s| s.approved?}.map &:domain_id
      else
        domain_ids = shop_manager.shop_manager_domains.map &:domain_id
      end
    end
    domains = Domain.list_domain_by_ids domain_ids
    domains.map{|domain| [domain.name, domain.id]}
  end

  def user_name_for_id id
    user = User.find_by id: id
    user.name if user
  end

  def order_manage_filter
    {I18n.t("order_manage_filter.product") => "product",
      I18n.t("order_manage_filter.user") => "user"}
  end

  def sum_price orders
    orders.sum{|order| total_price(order.product_price, order.quantity)}
  end

  def group_by_user orders
    orders.group_by{|u| u.user_id}
  end

  def accepted_products order_products
    order_products.sum{|o| o.accepted? || o.done? ? o.quantity : 0 }
  end

  def rejected_products order_products
    order_products.sum{|o| o.rejected? ? o.quantity : 0 }
  end

  def total_pay order_products
    order_products.sum{|o| o.accepted? || o.done? || o.pending? ? o.quantity * o.product_price : 0}
  end
end
