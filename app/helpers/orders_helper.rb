module OrdersHelper
  def shop_domain_select shop
    shop.domains.map{|domain| [domain.name, domain.id]}
  end
end
