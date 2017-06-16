class Dashboard::OrdersController < BaseDashboardController
  before_action :load_shop, except: :show, only: :index
  before_action :load_shop_order, only: [:show, :edit, :destroy]
  before_action :check_owner_or_manager, only: [:index, :show]

  def index
    orders = Order.by_domain(params[:domain_id]).orders_of_shop_pending params[:shop_id]
    load_order_product orders, params[:type]
    load_list_toal_orders
    if request.xhr?
      respond_to do |format|
        format.js
      end
    end
  end

  def edit
  end

  def show
    @order_products = @order.order_products.accepted.group_product
  end

  def update
    if params[:order].present?
      render_json_shop
    else
      order = Order.find_by id: params[:id]
      render_json_shop
      send_mail_to_user order.order_products
      flash[:success] = t "flash.success.update_order"
      redirect_to edit_dashboard_shop_order_path(@shop.id, order.id)
    end
  end

  def create
    @order = @shop.orders.new order_params_create
    if @order.save
      flash[:success] = t "flash.success.create_order"
      redirect_to dashboard_shop_orders_path
    else
      render :back
    end
  end

  def destroy
    if @order.destroy
      flash[:success] = t "oder.deleted"
    else
      flash[:danger] = t "oder.not_delete"
    end
    redirect_to dashboard_shop_orders_path
  end

  private
  def order_params
    params.require(:order).permit(:status).merge! change_status: true
  end

  def order_params_create
    params.require(:order).permit(:end_at, :notes)
      .merge! user: current_user, change_status: true
  end

  def load_shop_order
    shop = Shop.find_by id: params[:shop_id]
    if shop
      @order = shop.orders.includes(:products).find_by id: params[:id]
      unless @order
        flash[:danger] = t "flash.danger.load_order"
        redirect_to dashboard_shop_orders_path
      end
    else
      flash[:danger] = t "flash.danger.load_shop"
      redirect_to dashboard_shops_path
    end
  end

  def send_mail_to_user products_order
    products_order.each do |product_order|
      OrderMailer.shop_confirmation(product_order).deliver_later
    end
  end

  def render_json_shop
    if @shop
      @order = @shop.orders.find_by id: params[:id]
      if @order.update_attributes order_params
        respond_to do |format|
          format.json do
            render json: {status: @order.status}
          end
        end
      end
    else
      render :back
    end
  end

  def load_order_product orders, type
    @order_products = {}
    @orders = []
    orders.each do |o|
      case type
      when Settings.filter_status_order.pending
        check_item o.order_products.select{|op| op.pending?}, o
      when Settings.filter_status_order.accepted
        check_item o.order_products.select{|op| op.accepted?}, o
      when Settings.filter_status_order.rejected
        check_item o.order_products.select{|op| op.rejected?}, o
      when Settings.filter_status_order.done
        check_item o.order_products.select{|op| op.done?}, o
      else
        @order_products[o.id] = o.order_products
        @orders << o
      end
    end
  end

  def check_item item, order
    if item.size > 0
      @order_products[order.id] = item
      @orders << order
    end
  end

  def load_list_toal_orders
    list_orders_id = Order.orders_of_shop_pending(@shop.id).select{|s|
      s.order_products.detect{|o| o.pending?} == nil}.pluck(:id)
    @list_products_packing = OrderProduct.all_order_product_of_list_orders(list_orders_id).order_products_accepted
  end
end
