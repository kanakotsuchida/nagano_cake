class Public::OrdersController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_customer!
  
  def index
    @orders = current_customer.orders
  end

  def show
    @order = Order.find(params[:id])
    @order_details = @order.order_details
    @total = @order.total_payment - 800
  end

  def new
    @order = Order.new
    @order_name = current_customer
    @addresses = current_customer.shopping_addresses
  end

  def confirmation
    @cart_items = current_customer.cart_items
    
    @order = Order.new(customer: current_customer,payment_method: params[:order][:payment_method])
    @total = @cart_items.sum(&:subtotal)
    @order.total_payment = @total + 800
    
    if params[:order][:my_address] == "1"
      @order.post_code = current_customer.post_code
      @order.address = current_customer.address
      @order.name = current_customer.full_name
      
    elsif params[:order][:my_address] == "2"
      ship = ShoppingAddress.find(params[:order][:address_id])
      @order.post_code = ship.post_code
      @order.address = ship.address
      @order.name = ship.name
      
    elsif params [:order][:my_address] == "3"
      @order.post_code = params[:order][:post_code]
      @order.address = params[:order][:address]
      @order.name = params[:order][:name]
      @ship = "1"
      
      unless @order.valid? == true
        @addresses = Address.where(customer: current_customer)
        render :new
      end
    end  
  end

  def complete
  end

  def create
      @cart_items = current_customer.cart_items
      @order = current_customer.orders.new(order_params)
      
       @order.save
        @cart_items.each do |cart_item|
        @order_detail = OrderDetail.new
        @order_detail.item_id = cart_item.item_id
        @order_detail.order_id = @order.id
        @order_detail.quantity = cart_item.quantity
        @order_detail.price = cart_item.item.with_tax_price
        @order_detail.save
        end
        
      if params[:order][:ship] == "1"
        current_customer.address.create(address_params)
      end
        
        @cart_items.destroy_all
        
        redirect_to complete_path
      
  end

  private

  def order_params
    params.require(:order).permit(:post_code, :address, :name, :payment_method, :total_payment)
  end
  
  def address_params
    params.require(:order).permit(:post_code, :address, :name)
  end
end
 